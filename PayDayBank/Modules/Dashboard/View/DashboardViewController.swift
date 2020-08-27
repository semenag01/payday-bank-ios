//
//  DashboardViewController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class DashboardViewController: TableViewController {
    var output: DashboardViewOutput?
    private var sections: [DashboardSectionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Dashboard"
        
        output?.viewDidLoad()
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.register(UINib(nibName: DashboardCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DashboardCell.reuseIdentifier)
        tableView.register(UINib(nibName: DashboardSectionHeaderViewView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: DashboardSectionHeaderViewView.reuseIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dashboardCell: DashboardCell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.reuseIdentifier, for: indexPath) as? DashboardCell {
            let cellViewModel: DashboardCellViewModel = sections[indexPath.section].cells[indexPath.row]
            dashboardCell.setupWith(viewModel: cellViewModel)
            return dashboardCell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView: DashboardSectionHeaderViewView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DashboardSectionHeaderViewView.reuseIdentifier) as? DashboardSectionHeaderViewView {
            let sectionViewModel: DashboardSectionViewModel = sections[section]
            headerView.setupWith(date: sectionViewModel.dateStr,
                                 amount: sectionViewModel.amountStr,
                                 color: sectionViewModel.amountColor,
                                 isFirstSection: section == 0)
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

extension DashboardViewController: DashboardViewInput {
    func update(with sections: [DashboardSectionViewModel]) {
        self.sections = sections
    }    
}
