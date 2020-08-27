//
//  DashboardViewModel.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

struct DashboardSectionViewModel {
    let cells: [DashboardCellViewModel]
    let date: Date
    let amount: Double
    
    var dateStr: String? {
        DateConverter.shared.convertDateToBaseMonthString(date: date)
    }
    
    var amountStr: String? {
        return amount.format(f: ".2")
    }
    
    var amountColor: UIColor {
        amount < 0 ? .systemRed : .systemGreen
    }
}

struct DashboardCellViewModel {
    let category: String
    let amount: Double
    
    var amountStr: String? {
        return amount.format(f: ".2")
    }
    
    var amountColor: UIColor {
        amount < 0 ? .systemRed : .systemGreen
    }
}
