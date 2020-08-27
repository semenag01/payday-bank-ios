//
//  AccountsDataBaseRequest.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import CoreData
import DataBase

class AccountsDataBaseRequest: DataBaseRequest<BOAccount, [Account]> {
    override func process(result: Result<[BOAccount], Error>) -> SMResponse<[Account]> {
        let response: SMResponse = SMResponse<[Account]>()
        
        switch result {
        case .success(let data):
            let accounts: [Account] = data.map {
                Account(id: $0.identifier,
                        customerId: $0.customerId,
                        iban: $0.iban,
                        type: $0.type,
                        dateCreated: $0.dateCreated,
                        active: $0.active)
            }
            response.data = accounts
            response.isSuccess = true
        case .failure(let error):
            response.error = error
        }
        
        response.isSuccess = response.error != nil && !response.isCancelled
        return response
    }
}
