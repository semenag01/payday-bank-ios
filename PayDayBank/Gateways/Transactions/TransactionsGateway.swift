//
//  TransactionsGateway.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import DataBase
import Backend

class TransactionsGateway: SMGateway, DataFetcherRequestable {
    typealias T = [Transaction]
    
    private let sessionStorage: SessionStorable
    
    init(sessionStorage: SessionStorable) {
        self.sessionStorage = sessionStorage
    }
    
    func getRequest() -> SMRequest<T>? {
        guard let accountId: Int64 = sessionStorage.user?.identifier else { return nil }
        
        var params: [String: AnyObject] = [:]
        params["account_id"] = accountId as AnyObject
        
        return request(type: .get, path: "transactions", parameters: params, model: T.self)
    }
    
    func getDateBaseRequest() -> SMRequest<T>? {
        return TransactionsDataBaseRequest(storage: SMDBStorageConfigurator.storage,
                                           fetchRequest: BOTransaction.allObjectsNSFetchRequest())
    }
}
