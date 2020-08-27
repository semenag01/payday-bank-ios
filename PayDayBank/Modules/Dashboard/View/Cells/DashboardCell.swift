//
//  DashboardCell.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: DashboardCell.self)
    
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    func setupWith(viewModel: DashboardCellViewModel) {
        lbAmount.text = viewModel.amountStr
        lbCategory.text = viewModel.category
        lbAmount.textColor = viewModel.amountColor
    }
}
