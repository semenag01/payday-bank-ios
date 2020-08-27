//
//  AccountsGateway.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import DataBase
import Backend

class AccountsGateway: SMGateway, DataFetcherRequestable {
    typealias T = [Account]
    
    private let sessionStorage: SessionStorable
    
    init(sessionStorage: SessionStorable) {
        self.sessionStorage = sessionStorage
    }
    
    func getRequest() -> SMRequest<T>? {
        guard let accountId: Int64 = sessionStorage.user?.identifier else { return nil }

        var params: [String: AnyObject] = [:]
        params["customer_id"] = accountId as AnyObject
        
        return request(type: .get,
                       path: "accounts",
                       parameters: params,
                       model: T.self,
                       dateDecodingStrategy: .formatted(DateFormatter.shortServerFormat))
    }
    
    func getDateBaseRequest() -> SMRequest<T>? {
        return AccountsDataBaseRequest(storage: SMDBStorageConfigurator.storage,
                                           fetchRequest: BOAccount.allObjectsNSFetchRequest())
    }
}
