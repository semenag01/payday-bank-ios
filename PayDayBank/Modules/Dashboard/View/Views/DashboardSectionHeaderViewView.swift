//
//  DashboardSectionHeaderViewView.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class DashboardSectionHeaderViewView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: DashboardSectionHeaderViewView.self)

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var vTopSeparator: UIView!
    
    func setupWith(date: String?, amount: String?, color: UIColor, isFirstSection: Bool) {
        
        lbDate.text = date
        lbAmount.text = amount
        lbAmount.textColor = color
        vTopSeparator.isHidden = isFirstSection
    }
}
