//
//  AccountViewController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class AccountViewController: TableViewController {
    
    var output: AccountViewOutput?
    private var sections: [AccountSectionViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account"
        setupRightBarButtonItem()
        output?.viewDidLoad()
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.register(UINib(nibName: AccountCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AccountCell.reuseIdentifier)
    }
    
    private func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "chevron.right.square"),
                                                  style: .plain, target: self, action: #selector(onLogout))
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let accountCell: AccountCell = tableView.dequeueReusableCell(withIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell {
            let cellViewModel: AccountCellViewModel = sections[indexPath.section].cells[indexPath.row]
            accountCell.setupWith(viewModel: cellViewModel)
            return accountCell
        }
        
        return .init()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    // MARK: - Actions
    
    @objc func onLogout() {
        let alert: UIAlertController = UIAlertController(title: "Warning",
                                                         message: "Are you sure you want to log out?",
                                                         preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "YES", style: .destructive, handler: { [weak self] _ in
            self?.output?.logout()
        }))
        
        present(alert, animated: true)
    }
}

extension AccountViewController: AccountViewInput {
    func update(with sections: [AccountSectionViewModel]) {
        self.sections = sections
    }    
}
