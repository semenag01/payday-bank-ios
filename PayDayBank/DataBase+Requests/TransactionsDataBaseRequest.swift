//
//  TransactionsDataBaseRequest.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import CoreData
import DataBase

class TransactionsDataBaseRequest: DataBaseRequest<BOTransaction, [Transaction]> {
    override func process(result: Result<[BOTransaction], Error>) -> SMResponse<[Transaction]> {
        let response: SMResponse = SMResponse<[Transaction]>()
        
        switch result {
        case .success(let data):
            let transactions: [Transaction] = data.map {
                Transaction(id: $0.identifier,
                            date: $0.date,
                            category: $0.category,
                            amount: $0.amount,
                            vendor: $0.vendor)
            }
            response.data = transactions
            response.isSuccess = true
        case .failure(let error):
            response.error = error
        }
        
        response.isSuccess = response.error != nil && !response.isCancelled
        return response
    }
}
