import FastModule
import Alamofire

public class FastModuleHTTP: DynamicModuleTemplate {
    public func setupChildModules(nestable: Nestable) {}
    
    public func setupBindings(executable: Executable) {
        executable.bindAction(pattern: ":content-type/:method/:url") { (param, responder, request) in
            do {
                let methodString = try param.required(":method", type: String.self)
                let contentType = try param.required(":content-type", type: String.self)
                let url = try param.required(":url", type: String.self)
                
                let parameters = param.optional("parameters", type: [String: Any].self)
                let headers = param.optional("headers", type: [String: String].self)
                
                switch contentType {
                    case "json": self.requestJSON(url: url, method: HTTPMethod.fromString(methodString), parameters: parameters, headers: headers, responder: responder)
                    case "text": self.requestText(url: url, method: HTTPMethod.fromString(methodString), parameters: parameters, headers: headers, responder: responder)
                    case "data": self.requestData(url: url, method: HTTPMethod.fromString(methodString), parameters: parameters, headers: headers,  responder: responder)
                    default: self.requestText(url: url, method: HTTPMethod.fromString(methodString), parameters: parameters, headers: headers,  responder: responder)
                }
                
            } catch {
                responder.failure(error: error)
            }
        }
    }
    
    public func setupObservations(observeable: Observeable) {}
    
    public required init() {}
}

extension FastModuleHTTP {
    fileprivate func requestJSON(url: URLConvertible,
                         method: HTTPMethod,
                         parameters: Parameters? = nil,
                         headers: HTTPHeaders? = nil,
                         responder: ActionResponder) {
        
        let task = AlamofireNetworkManager
            .requestJSON(url: url,
                         method: method,
                         parameters: parameters,
                         headers: headers, callback: {
                            switch ($0, $1) {
                            case (_, let error?):
                                responder.failure(error: error)
                            case (let value, nil):
                                responder.success(value: value)
                            }
            })
        
        responder.onCancel {
            task?.cancel()
        }
    }
    
    fileprivate func requestData(url: URLConvertible,
                                 method: HTTPMethod,
                                 parameters: Parameters? = nil,
                                 headers: HTTPHeaders? = nil,
                                 responder: ActionResponder) {
        
        let task = AlamofireNetworkManager
            .requestData(url: url,
                         method: method,
                         parameters: parameters,
                         headers: headers, callback: {
                            switch ($0, $1) {
                            case (_, let error?):
                                responder.failure(error: error)
                            case (let value, nil):
                                responder.success(value: value)
                            }
            })
        
        responder.onCancel {
            task?.cancel()
        }
    }
    
    fileprivate func requestText(url: URLConvertible,
                                 method: HTTPMethod,
                                 parameters: Parameters? = nil,
                                 headers: HTTPHeaders? = nil,
                                 responder: ActionResponder) {
        
        let task = AlamofireNetworkManager
            .requestText(url: url,
                         method: method,
                         parameters: parameters,
                         headers: headers, callback: {
                            switch ($0, $1) {
                            case (_, let error?):
                                responder.failure(error: error)
                            case (let value, nil):
                                responder.success(value: value)
                            }
            })
        
        responder.onCancel {
            task?.cancel()
        }
    }
}

