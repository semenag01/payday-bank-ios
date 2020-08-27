//
//  SMGatewayRequest.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

public typealias SMGatewayRequestResponseBlock<T> = (DataRequest, AFDataResponse<Any>) -> SMResponse<T>

public typealias SMRequestParserBlock<T> = (SMResponse<T>) -> Void
public typealias SMGatewayRequestSuccessParserBlock<T> = (DataRequest, AFDataResponse<Any>, @escaping SMRequestParserBlock<T>) -> Void

open class SMGatewayRequest<T>: SMRequest<T> {

    public var debugDescription: String {
        
        var array: [String] = []
        
        array.append("URL - " + (dataRequest?.request?.url?.absoluteString ?? (fullPath?.absoluteString) ?? ""))
        array.append("TYPE - " + type.rawValue)
        array.append("HEADERS - " + allHeaders.description)
        array.append("PARAMS - " + allParams.description)
        
        return  array.joined(separator: "\n") + "\n"
    }
    
    //open weak var delegate: SMGatewayRequestDelegate?
    
    open var type: HTTPMethod
    open var session: Session
    
    open var dataRequest: DataRequest?
    
    open var retryCount: Int = 0
    open var retryTime: TimeInterval = 0.5
    
    open var path: String?
    open var parameters: [String: AnyObject]?
    open var headers: [String: String]?
    open var parameterEncoding: ParameterEncoding?
    
    open var successBlock: SMGatewayRequestResponseBlock<T>?
    open var successParserBlock: SMGatewayRequestSuccessParserBlock<T>?
    open var failureBlock: SMGatewayRequestResponseBlock<T>?
    
    open var printCURLDescription: Bool = true
    
    public let baseUrl: () -> URL?
    public let isInternetReachable: () -> Bool
    
    open var defaultParameters: (() -> [String: AnyObject]?)?
    open var defaultHeaders: (() -> [String: String]?)?
    open var acceptableStatusCodes: (() -> [Int]?)?
    open var acceptableContentTypes: (() -> [String]?)?
    open var interceptor: (() -> SMRequestInterceptor<T>?)?
    
    open var allParams: [String: Any] {
        
        var result: [String: Any] = [:]
        
        if let defaultParameters: [String: AnyObject] = defaultParameters?() {
            
            for (key, value): (String, AnyObject) in defaultParameters {
                
                result.updateValue(value, forKey: key)
            }
        }
        
        if let parameters: [String: AnyObject] = parameters {
            
            for (key, value): (String, AnyObject) in parameters {
                
                result.updateValue(value, forKey: key)
            }
        }
        
        return result
    }
    
    open var allHeaders: HTTPHeaders {
        
        var result: HTTPHeaders = HTTPHeaders()
        
        if let defaultHeaders: [String: String] = defaultHeaders?() {
            
            for (key, value): (String, String) in defaultHeaders {
                
                result.update(name: key, value: value)
            }
        }
        
        if let headers: [String: String] = headers {
            
            for (key, value): (String, String) in headers {
                
                result.update(name: key, value: value)
            }
        }
        
        return result
    }
    
    open var allAcceptableStatusCodes: [Int]? {
        
        var result: [Int]?
                
        if let acceptableStatusCodes: [Int] = acceptableStatusCodes?() {
            
            if result == nil {
                result = []
            }
            
            result?.append(contentsOf: acceptableStatusCodes)
        }
        
        if let acceptableStatusCodes: [Int] = acceptableStatusCodes?() {
            
            if result == nil {
                result = []
            }
            
            result?.append(contentsOf: acceptableStatusCodes)
        }
        
        return result
    }
    
    open var allAcceptableContentTypes: [String]? {
        
        var result: [String]?
                
        if let acceptableContentTypes: [String] = acceptableContentTypes?() {
            
            if result == nil {
                result = []
            }
            
            result?.append(contentsOf: acceptableContentTypes)
        }
        
        if let acceptableContentTypes: [String] = acceptableContentTypes?() {
            
            if result == nil {
                result = []
            }
            
            result?.append(contentsOf: acceptableContentTypes)
        }
        
        return result
    }
    
    open var fullPath: URL? {
        
        var result: URL?
        
        if let baseUrl: URL = baseUrl() {
            
            result = baseUrl
            
            if let path: String = path {
                result = baseUrl.appendingPathComponent(path)
            }
        } else if let path: String = path {
            
            result = URL(string: path)
        }
        
        return result
    }
    
    public init(session: Session,
                type: HTTPMethod,
                baseUrl: @escaping () -> URL?,
                isInternetReachable: @escaping () -> Bool) {
        self.session = session
        self.type = type
        self.baseUrl = baseUrl
        self.isInternetReachable = isInternetReachable
    }
    
    
    // MARK: -
    
    @discardableResult
    override open func start() -> Self {
        
        if let dataRequest: DataRequest = getDataRequest() {
            
            super.start()
            
            if let acceptableStatusCodes: [Int] = allAcceptableStatusCodes {
                dataRequest.validate(statusCode: acceptableStatusCodes)
            }
            
            if let acceptableContentTypes: [String] = allAcceptableContentTypes {
                dataRequest.validate(contentType: acceptableContentTypes)
            }
            
            self.dataRequest = dataRequest
            
            printCURLIfNeeded()
            
            dataRequest.resume()
        }
        
        return self
    }
    
    override open func cancel() {
        
        dataRequest?.cancel()
    }
    
    override open func canExecute() -> Bool {
        
        let result: Bool = isInternetReachable() == true
        
        return result
    }
    
    override open func isCancelled() -> Bool {
        
        return dataRequest?.task?.state == .completed
    }
    
    override open func isExecuting() -> Bool {
        
        return dataRequest?.task?.state == .running
    }
    
    override open func isFinished() -> Bool {
        
        return dataRequest?.task?.state == .completed
    }
    
    
    // MARK: -
    
    open func parameterEncoding(for type: HTTPMethod) -> ParameterEncoding? {
        
        let result: ParameterEncoding?
        
        if let parameterEncoding: ParameterEncoding = parameterEncoding {
            result = parameterEncoding
        } else {
            switch type {
            case .options, .head, .get, .delete:
                result = URLEncoding.default
            case .patch, .post, .put:
                result = JSONEncoding.default
            default:
                result = nil
            }
        }
        
        return result
    }
    
    func printCURLIfNeeded() {
        
        if printCURLDescription {
            
            dataRequest?.cURLDescription(calling: {
                print("""
                    \n\nRequest start:
                    cURL description \(self)
                    **********************
                    \($0)
                    **********************
                    """)
            })
        }
    }
    
    open func getDataRequest() -> DataRequest? {
        
        guard let fullPath: URL = fullPath,
            let parameterEncoding = parameterEncoding(for: type) else { return  nil }
                                        
        let dataRequest: DataRequest = session.request(fullPath,
                                                       method: type,
                                                       parameters: allParams,
                                                       encoding: parameterEncoding,
                                                       headers: allHeaders,
                                                       interceptor: interceptor?())
                
        dataRequest.responseJSON(completionHandler: {[weak self] responseObject in
            self?.processResponseObject(responseObject, forDataRequest: dataRequest)
        })
        
        return dataRequest
    }
    
    open func processResponseObject(_ responseObject: AFDataResponse<Any>, forDataRequest dataRequest: DataRequest) {
        
        switch responseObject.result {
        case .success:
            let callBack: SMRequestParserBlock = { [weak self] (aResponse: SMResponse) in
                self?.executeAllResponseBlocks(response: aResponse)
            }
            
            if let successParserBlock: SMGatewayRequestSuccessParserBlock = successParserBlock {
                
                successParserBlock(dataRequest, responseObject, callBack)
            } else if let response: SMResponse = successBlock?(dataRequest, responseObject) {
                
                callBack(response)
            }
        case .failure(let error):
            print("Request failed with error: \(error)")
            executeFailureBlock(responseObject: responseObject)
        }
    }
    
    open func executeSuccessBlock(responseObject aResponseObject: AFDataResponse<Any>) {
        
        if let successBlock: SMGatewayRequestResponseBlock = successBlock,
            let dataRequest: DataRequest = dataRequest {
            
            let response: SMResponse = successBlock(dataRequest, aResponseObject)
            
            executeAllResponseBlocks(response: response)
        }
    }
    
    open func executeFailureBlock(responseObject aResponseObject: AFDataResponse<Any>) {
        
        if let failureBlock: SMGatewayRequestResponseBlock = failureBlock,
            let dataRequest: DataRequest = dataRequest {
            
            let response: SMResponse = failureBlock(dataRequest, aResponseObject)
            
            executeAllResponseBlocks(response: response)
        }
    }
    
    open func setup(successBlock aSuccessBlock: @escaping SMGatewayRequestResponseBlock<T>,
                    failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock<T>) {
        
        successBlock = aSuccessBlock
        failureBlock = aFailureBlock
    }
    
    open func setup(successParserBlock aSuccessParserBlock: @escaping SMGatewayRequestSuccessParserBlock<T>,
                    failureBlock aFailureBlock: @escaping SMGatewayRequestResponseBlock<T>) {
        
        successParserBlock = aSuccessParserBlock
        failureBlock = aFailureBlock
    }
}

extension Result {
    init(value: Success, error: Failure?) {
        if let error: Failure = error {
            self = .failure(error)
        } else {
            self = .success(value)
        }
    }
}
