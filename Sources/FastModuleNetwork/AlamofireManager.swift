//
//  AlamofireManager.swift
//  Network
//
//  Created by ian luo on 2017/8/15.
//  Copyright © 2017年 ianluo. All rights reserved.
//

import Foundation
import Alamofire

internal class AlamofireNetworkManager {
    private struct Constants {
        static let reachability = NetworkReachabilityManager()
    }
    
    internal static func download(path: String,
                                  callback: @escaping (Data?, Error?) -> Void,
                                  progress: @escaping (Double) -> Void) throws -> URLSessionTask? {
        let request = Alamofire.request(path)
        request.downloadProgress {
                let value = Double($0.completedUnitCount) / Double($0.totalUnitCount)
                progress(value)
            }.responseData {
                if let error = $0.error {
                    callback(nil, error)
                } else {
                    callback($0.value, nil)
                }
        }
        return request.task
    }
    
    internal static func requestJSON(url: URLConvertible,
                                     method: HTTPMethod,
                                     parameters: Parameters?,
                                     headers: HTTPHeaders?,
                                     callback: @escaping (Any?, Error?) -> Void) -> URLSessionTask? {
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding(),
                                        headers: headers)
        
        request.responseJSON(queue: nil, options: []) { response in
            switch response.result {
            case .failure(let error):
                callback(nil, error)
            case .success(let value):
                callback(value, nil)
            }
        }
        
        return request.task
    }
    
    internal static func requestData(url: URLConvertible,
                                     method: HTTPMethod,
                                     parameters: Parameters?,
                                     headers: HTTPHeaders?,
                                     callback: @escaping (Data?, Error?) -> Void) -> URLSessionTask? {
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding(),
                                        headers: headers)
        
        request.responseData(queue: nil) { response in
            switch response.result {
            case .failure(let error):
                callback(nil, error)
            case .success(let value):
                callback(value, nil)
            }
        }
        
        return request.task
    }
    
    internal static func requestText(url: URLConvertible,
                                     method: HTTPMethod,
                                     parameters: Parameters?,
                                     headers: HTTPHeaders?,
                                     callback: @escaping (String?, Error?) -> Void) -> URLSessionTask? {
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: parameters,
                                        encoding: JSONEncoding(),
                                        headers: headers)
        
        request.responseString(queue: nil) { response in
            switch response.result {
            case .failure(let error):
                callback(nil, error)
            case .success(let value):
                callback(value, nil)
            }
        }
        
        return request.task
    }
}

extension Alamofire.HTTPMethod {
    internal static func fromString(_ s: String) -> HTTPMethod {
        return { (methodString: String) -> HTTPMethod in
            switch methodString.lowercased() {
            case "get": return .get
            case "post": return .post
            case "delete": return .delete
            case "put": return .put
            case "head": return .head
            case "trace": return .trace
            case "connect": return .connect
            case "options": return .options
            default: return .get
            }
        }(s)
    }
}
