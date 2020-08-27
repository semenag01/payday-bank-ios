//
//  TransactionListSectionHeaderView.swift
//  PayDayBank
//
//  Created by Developer on 06.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class TransactionListSectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: TransactionListSectionHeaderView.self)

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var vTopSeparator: UIView!
    
    func setupWith(date: String?, isFirstSection: Bool) {
        lbDate.text = date
        vTopSeparator.isHidden = isFirstSection
    }
}
