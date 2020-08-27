//
//  SMRequestRetrier.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

open class SMRequestRetrier<T>: RequestRetrier {
    
    public let request: SMGatewayRequest<T>
    public private(set) var retryCount: Int = 0
    
    public init(request: SMGatewayRequest<T>) {
        
        self.request = request
        retryCount = request.retryCount
    }
    
    
    // MARK: - RequestRetrier
    
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        
        if retryCount == 0 || (error as NSError?)?.code == NSURLErrorCancelled {
            
            completion(.doNotRetry)
            
        } else {
            
            completion(.retryWithDelay(self.request.retryTime))
            print("\n\nRETRY", self.request.debugDescription)
        }
    }
}
