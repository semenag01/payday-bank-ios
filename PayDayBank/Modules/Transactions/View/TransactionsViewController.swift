//
//  TransactionsViewController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class TransactionsViewController: TableViewController {
    var output: TransactionsViewOutput?
    private var sections: [TransactionsSectionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transactions"
        output?.viewDidLoad()
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.register(UINib(nibName: TransactionListCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TransactionListCell.reuseIdentifier)
        tableView.register(UINib(nibName: TransactionListSectionHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: TransactionListSectionHeaderView.reuseIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let transactionListCell: TransactionListCell = tableView.dequeueReusableCell(withIdentifier: TransactionListCell.reuseIdentifier, for: indexPath) as? TransactionListCell {
            let cellViewModel: TransactionsCellViewModel = sections[indexPath.section].cells[indexPath.row]
            transactionListCell.setupWith(viewModel: cellViewModel)
            return transactionListCell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView: TransactionListSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionListSectionHeaderView.reuseIdentifier) as? TransactionListSectionHeaderView {
            let sectionViewModel: TransactionsSectionViewModel = sections[section]
            headerView.setupWith(date: sectionViewModel.dateStr, isFirstSection: section == 0)
            
            return headerView
        }
        
        return nil
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension TransactionsViewController: TransactionsViewInput {
    func update(with sections: [TransactionsSectionViewModel]) {
        self.sections = sections
    }    
}
