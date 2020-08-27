//
//  SMGateway.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

public protocol SMGateway {
    
    associatedtype T
    
    var gatewayConfigurator: SMGatewayConfigurator { get }
    
    func adapter(for request: SMGatewayRequest<T>) -> SMRequestAdapter<T>
    func retrier(for request: SMGatewayRequest<T>) -> SMRequestRetrier<T>
    
    func defaultFailureBlockFor<T>(request aRequest: SMGatewayRequest<T>) -> SMGatewayRequestResponseBlock<T>
}

public extension SMGateway {
    
    var session: Session {
        return Session.default
    }
    
    
    // MARK: - SMGateway
    
    var gatewayConfigurator: SMGatewayConfigurator {
        
        let configurator: SMGatewayConfigurator = SMGatewayConfigurator.shared
        
        return configurator
    }
    
    func adapter(for request: SMGatewayRequest<T>) -> SMRequestAdapter<T> {
        
        let adapter: SMRequestAdapter = SMRequestAdapter(request: request)
        
        return adapter
    }
    
    func retrier(for request: SMGatewayRequest<T>) -> SMRequestRetrier<T> {
        
        let retrier: SMRequestRetrier = SMRequestRetrier(request: request)
        
        return retrier
    }
    
    func defaultFailureBlockFor(request aRequest: SMGatewayRequest<T>) -> SMGatewayRequestResponseBlock<T> {
        
        func result(data: DataRequest, responseObject: AFDataResponse<Any>) -> SMResponse<T> {
            
            let isCanceled: Bool = {
                
                let result: Bool
                
                if case let .sessionTaskFailed(error): AFError? = responseObject.error,
                    (error as NSError).code == NSURLErrorCancelled {
                    result = true
                } else if responseObject.error?.isExplicitlyCancelledError == true {
                    result = true
                } else {
                    result = false
                }
                
                return result
            }()
            
            let response: SMResponse = SMResponse<T>()
            response.isCancelled = isCanceled
            response.isSuccess = false
            response.error = responseObject.error
            
            return response
        }
        
        return result
    }
    
    
    // MARK: Create requests
    
    func request<T: Codable>(type: HTTPMethod,
                             path: String,
                             parameters: [String: AnyObject]? = nil,
                             model: T.Type,
                             dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(DateFormatter.baseServerFormat)) -> SMGatewayRequest<T> {
        
        let result: SMGatewayRequest = SMGatewayRequest<T>.init(session: session,
                                                                type: type,
                                                                baseUrl: { self.gatewayConfigurator.baseUrl },
                                                                isInternetReachable: { self.gatewayConfigurator.isInternetReachable })
        
        result.path = path
        
        if let parameters: [String: AnyObject] = parameters {
            
            result.parameters = parameters
        }
        
        let failureBlock: SMGatewayRequestResponseBlock = defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: { _, dataResponse in
            let response: SMResponse = SMResponse<T>()
            do {
                guard let data: Data = dataResponse.data else {
                    return response
                }
                
                let jsonDecoder: JSONDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseData: T = try jsonDecoder.decode(T.self, from: data)
                response.isSuccess = true
                response.data = responseData
            } catch {
                response.error = error
                print(error)
            }
            return response
        }, failureBlock: failureBlock)
        
        return result
    }
    
    func defaultFailureBlockFor<T>(request aRequest: SMGatewayRequest<T>) -> SMGatewayRequestResponseBlock<T> {
        func result(data: DataRequest, responseObject: AFDataResponse<Any>) -> SMResponse<T> {
            let response: SMResponse = SMResponse<T>()
             response.error = responseObject.error

             var errorMessage: String?
             
             if let data: Data = responseObject.data {
                 
                 if let json: String = String(data: data, encoding: String.Encoding.utf8) {
                     
                     errorMessage = json
                 }
             }

             if errorMessage == nil || errorMessage?.isEmpty == true {
                 
                 errorMessage = response.error?.localizedDescription
             }
             response.isCancelled = (responseObject.error as NSError?)?.code == NSURLErrorCancelled
             response.isSuccess = false
             
             return response
         }
         
         return result
    }
}
