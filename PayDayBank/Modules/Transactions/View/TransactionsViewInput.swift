//
//  TransactionsViewInput.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

protocol TransactionsViewInput: ViewInput {
    func update(with sections: [TransactionsSectionViewModel])
}
