//
//  SMRequestAdapter.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

open class SMRequestAdapter<T>: RequestAdapter {

    public let request: SMGatewayRequest<T>
    
    public init(request: SMGatewayRequest<T>) {
        self.request = request
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {        
        completion(.success(urlRequest))
    }
}
