//
//  NetworkService.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 08.01.2023.
//

import UIKit

protocol HttpRequestManagerDelegate: AnyObject {
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
