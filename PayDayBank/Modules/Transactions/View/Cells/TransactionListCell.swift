//
//  TransactionListCell.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class TransactionListCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: TransactionListCell.self)
    
    @IBOutlet weak var lbVendor: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    func setupWith(viewModel: TransactionsCellViewModel) {
        lbVendor.text = viewModel.vendor
        lbAmount.text = viewModel.amountStr
        lbCategory.text = viewModel.category
        lbTime.text = viewModel.dateStr
        lbAmount.textColor = viewModel.amountColor
    }
}
