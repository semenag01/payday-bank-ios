//
//  TransactionsPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend

class TransactionsPresenter<V: TransactionsViewInput>: Presenter<V> {
    
    var interactor: TransactionsInteractorInput?
}

extension TransactionsPresenter: TransactionsViewOutput {
    func viewDidLoad() {
        interactor?.fetchData()
    }
}

extension TransactionsPresenter: TransactionsInteractorOutput {
    func didFetchData(_ models: [[Transaction]]) {
        let sectionViewModels: [TransactionsSectionViewModel] = models.compactMap { transactions in
            guard let date: Date = transactions.first?.date else { return nil }
            
            let cellViewModels: [TransactionsCellViewModel] =  transactions.compactMap {
                
                let cellViewModel: TransactionsCellViewModel = .init(vendor: $0.vendor,
                                                                     category: $0.category,
                                                                     date: $0.date,
                                                                     amount: $0.amountValue)
                
                return cellViewModel
            }
            
            let amount: Double = transactions.reduce(0.0) { $0 + $1.amountValue }
            
            let sectionViewModel: TransactionsSectionViewModel = .init(cells: cellViewModels,
                                                                       date: date,
                                                                       amount: amount)
            return sectionViewModel
        }
        
        viewController?.update(with: sectionViewModels)
    }
}
