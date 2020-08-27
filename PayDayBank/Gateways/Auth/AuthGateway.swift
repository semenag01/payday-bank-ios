//
//  AuthGateway.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend

class AuthGateway: SMGateway, AuthRequestable {
    typealias T = User
    
    func signInRequest(with model: SignInModel) -> SMRequest<T> {
        var params: [String: AnyObject] = [:]
        params["email"] = model.email as AnyObject
        params["password"] = model.password as AnyObject
        
        return request(type: .post,
                       path: "authenticate",
                       parameters: params,
                       model: T.self,
                       dateDecodingStrategy: .formatted(DateFormatter.secondaryServerFormat))
    }
    
    func signUpRequest(with model: SignUpModel) -> SMRequest<T> {
        var params: [String: AnyObject] = [:]
        params["First Name"] = model.firstName as AnyObject
        params["Last Name"] = model.lastName as AnyObject
        params["gender"] = model.gender as AnyObject
        params["email"] = model.email as AnyObject
        params["password"] = model.password as AnyObject
        params["dob"] = model.dob as AnyObject
        params["phone"] = model.phone as AnyObject
        
        return request(type: .post,
                       path: "customers",
                       parameters: params,
                       model: T.self,
                       dateDecodingStrategy: .formatted(DateFormatter.secondaryServerFormat))
    }
}
