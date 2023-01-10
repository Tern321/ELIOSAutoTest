//
//  NetworkService.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 08.01.2023.
//

import UIKit

protocol HttpRequestManagerDelegate {
    func requestFinished(requestData: ATRequest)
}

class NetworkService: NSObject {

    var requests: [String: ATRequest] = [:]
    var listeners: [String: [HttpRequestManagerDelegate]] = [:]
    func GET(requestData: ATRequest, delegate: HttpRequestManagerDelegate) {
        
    }
//    func operate(x: Double, y: Double, function: (Double, Double) -> Double) {
//        return function(x, y)
//    }
    
}

protocol NetworkManagerDelegate: AnyObject {
    // gotResponseForRequest() ->
}

class HttpRequestHelper2 {
    func GET(requestData: ATRequest, complete: @escaping (ATRequest) -> Void) {
        guard var components = URLComponents(string: requestData.url) else {
            print("Error: cannot create URLCompontents")
            return
        }
        components.queryItems = requestData.params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        switch requestData.httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }

        // .ephemeral prevent JSON from caching (They'll store in Ram and nothing on Disk)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                requestData.error = "Error: problem calling GET"
                complete(requestData)
                return
            }
            guard let data = data else {
                requestData.error = "Error: did not receive data"
                complete(requestData)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                requestData.error = "Error: HTTP request failed"
                complete(requestData)
                return
            }
            requestData.responseData = data
            complete(requestData)
        }.resume()
    }
}
