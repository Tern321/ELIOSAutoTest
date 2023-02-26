//
//  HttpRequestHelper.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 07.01.2023.
//

import UIKit
import AVFoundation
typealias RequestHash = String
typealias TargetDictionary = [String: RequestCallbackContainer]

protocol ATRequestDelegate: AnyObject {
    func finishedRequest(request: ATRequest)
}

class RequestCallbackContainer {
    init(target: AnyObject?, callback: @escaping (ATRequest) -> Void) {
        self.target = target
        self.callback = callback
    }
    
    weak var target: AnyObject?
    var callback: (ATRequest) -> Void // сделать weak?
}

class ATRequestHelper: ATRequestDelegate {
    
    func finishedRequest(request: ATRequest) {
        if let targetsDictionary = submitedForRequest[request.requestHash] {
            for target in targetsDictionary.values {
                if target.target != nil {
                    target.callback(request)
                }
            }
        }
        submitedForRequest[request.requestHash] = nil
        activeRequests[request.requestHash] = nil
    }
    
    static let shared = ATRequestHelper()
    // post
    // one thread
    // save exeqution queue
    private var submitedForRequest = [RequestHash: TargetDictionary]()
    private var activeRequests = [RequestHash: ATRequest]()
    // target // method
    func requestGet(url: String, params: [String: String], contentType: HTTPHeaderContentType?, target: AnyObject, callback: @escaping (ATRequest) -> Void) -> ATRequest {
        
        // add lock
        // use old request
        let request = ATRequest(url: url, params: params, contentType: contentType, delegate: self)
        let targetMemAddress = String.memoryAddress(obj: target)
        
        if !submitedForRequest.keys.contains(request.requestHash) {
            submitedForRequest[request.requestHash] = [:]
            request.run()
            activeRequests[request.requestHash] = request
            print("send request with hash \(request.requestHash)")
        } else {
            print("duplicated request")
        }
        var targetsDictionary = submitedForRequest[request.requestHash]!
        targetsDictionary[targetMemAddress] = RequestCallbackContainer(target: target, callback: callback)
        submitedForRequest[request.requestHash] = targetsDictionary
        return activeRequests[request.requestHash] ?? request
    }
}

class ATRequest {
    
    let requestId: String = NSUUID().uuidString
    let requestHash: RequestHash
    let url: String
    let params: [String: String]
    let contentType: HTTPHeaderContentType?
    
    fileprivate var responseData: Data?
    fileprivate var error: String?
    fileprivate weak var delegate: ATRequestDelegate?
    
    func getData() -> Data? {
        return responseData
    }
    func getError() -> String? {
        return error
    }
    
    fileprivate init(url: String, params: [String: String], contentType: HTTPHeaderContentType?, delegate: ATRequestDelegate) {
        self.delegate = delegate
        self.url = url
        self.params = params
        self.contentType = contentType
        requestHash = ATRequest.calculateRequestHash(url: url, params: params, contentType: contentType)
    }
    
    fileprivate func run() {
        guard var components = URLComponents(string: url) else {
            self.error = "Error: cannot create URLCompontents"
            self.delegate?.finishedRequest(request: self)
            return
        }
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else {
            self.error = "Error: cannot create URL"
            self.delegate?.finishedRequest(request: self)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderFields.contentType.rawValue)
        }

        // .ephemeral prevent JSON from caching (They'll store in Ram and nothing on Disk)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            self.responseData = data
            guard error == nil else {
                self.error = "Error: problem calling GET"
                self.delegate?.finishedRequest(request: self)
                return
            }
            guard let data = data else {
                self.error = "Error: did not receive data"
                self.delegate?.finishedRequest(request: self)
                print("Error: did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                self.error = "Error: HTTP request failed"
                self.delegate?.finishedRequest(request: self)
                return
            }
            self.responseData = data
            self.delegate?.finishedRequest(request: self)
        }.resume()
    }
    
    deinit {
        print("ATRequest deinit \(self.url)")
    }
    
    fileprivate static func calculateRequestHash(url: String, params: [String: String], contentType: HTTPHeaderContentType?) -> String {
        return "\(url) \(params.description) \(String(describing: contentType?.rawValue))"
    }
}

enum HTTPHeaderContentType: String {
    case application_json = "application/json"
    case application_x_www_form_urlencoded = "application/x-www-form-urlencoded"
    case other
}
    
enum HTTPHeaderFields: String {
    case contentType = "Content-Type"
}
