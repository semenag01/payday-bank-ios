//
//  AccountViewModel.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

struct AccountSectionViewModel {
    let cells: [AccountCellViewModel]
}

struct AccountCellViewModel {
    let iban: String
    let type: String
    let date: Date
    let active: Bool

    var dateStr: String? {
        DateConverter.shared.convertDateToBaseMonthString(date: date)
    }
}
