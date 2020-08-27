//
//  TransactionsViewModel.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

struct TransactionsSectionViewModel {
    let cells: [TransactionsCellViewModel]
    let date: Date
    let amount: Double
    
    var dateStr: String? {
        DateConverter.shared.convertDateToBaseDateString(date: date)
    }
    
    var amountStr: String? {
        return amount.format(f: ".2")
    }
    
    var amountColor: UIColor {
        amount < 0 ? .systemRed : .systemGreen
    }
}

struct TransactionsCellViewModel {
    let vendor: String?
    let category: String?
    let date: Date?
    let amount: Double
    
    var amountStr: String? {
        return amount.format(f: ".2")
    }
    
    var dateStr: String? {
        DateConverter.shared.convertDateToBaseTimeString(date: date)
    }
    
    var amountColor: UIColor {
        amount < 0 ? .systemRed : .systemGreen
    }
}
