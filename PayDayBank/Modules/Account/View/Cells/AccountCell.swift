//
//  AccountCell.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: AccountCell.self)

    @IBOutlet weak var lbIban: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbDateCreated: UILabel!
    @IBOutlet weak var lbIsActive: UILabel!
    
    func setupWith(viewModel: AccountCellViewModel) {
        lbIban.text = viewModel.iban
        lbType.text = viewModel.type
        lbDateCreated.text = viewModel.dateStr
        lbIsActive.text = "\(viewModel.active)".uppercased()
    }
}
