//
//  DashboardPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend

class DashboardPresenter<V: DashboardViewInput>: Presenter<V> {
    
    var interactor: DashboardInteractorInput?
}

extension DashboardPresenter: DashboardViewOutput {
    func viewDidLoad() {
        interactor?.fetchData()
    }
}

extension DashboardPresenter: DashboardInteractorOutput {
    func didFetchData(_ models: [[Transaction]]) {
        let sectionViewModels: [DashboardSectionViewModel] = models.compactMap { transactions in
            guard let date: Date = transactions.first?.date else { return nil }
            
            let processedTransactions: [[Transaction]] = transactions
                .sorted { $0.category.caseInsensitiveCompare($1.category) == .orderedAscending }
                .divide(comparator: {  $0.category == $1.category })
                        
            
            let cellViewModels: [DashboardCellViewModel] =  processedTransactions.compactMap {
                guard let category: String = $0.first?.category else {
                    return nil
                }
                
                let amount: Double = $0.reduce(0.0) { $0 + $1.amountValue}
                
                let cellViewModel: DashboardCellViewModel = .init(
                    category: category,
                    amount: amount)
                
                return cellViewModel
            }
            
            let amount: Double = transactions.reduce(0.0) { $0 + $1.amountValue }
            
            let sectionViewModel: DashboardSectionViewModel = .init(cells: cellViewModels,
                                                                    date: date,
                                                                    amount: amount)
            return sectionViewModel
        }
        
        viewController?.update(with: sectionViewModels)
    }
}
