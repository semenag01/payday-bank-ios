//
//  TransactionsInteractor.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import DataBase

class TransactionsInteractor<F: Fetcher>: TransactionsInteractorInput where F.T == [Transaction] {
    typealias T = [Transaction]
    
    private let dataFetcher: F
    private weak var output: TransactionsInteractorOutput?
    private let dataBasetorage: DataBaseStorable
    
    init(dataFetcher: F,
         output: TransactionsInteractorOutput,
         dataBasetorage: DataBaseStorable) {
        self.dataFetcher = dataFetcher
        self.output = output
        self.dataBasetorage = dataBasetorage
    }
    
    deinit {
        print(#function, #file)
    }
    
    private func process(models: T) {
        guard !models.isEmpty else {
            return
        }
        
        let processedModels: [T] = models
            .sorted { $0.date > $1.date }
            .divide(comparator: { Calendar.current.isDate($0.date, inSameDayAs: $1.date) })

        output?.didFetchData(processedModels)
    }
    
    private func saveToDataBase(transactions: [Transaction]) {
        dataBasetorage.save(block: { context in
            transactions.forEach {
                let boTransaction: BOTransaction = BOTransaction.objectByID($0.id) ?? BOTransaction(context: context)
                boTransaction.identifier = $0.id
                boTransaction.date = $0.date
                boTransaction.category = $0.category
                boTransaction.amount = $0.amount
                boTransaction.vendor = $0.vendor
            }
        }, completion: nil)
    }
}

extension TransactionsInteractor {
    func fetchData() {
        dataFetcher.fetchData(withCallback: { [weak self] response in
            DispatchQueue.main.async {
                self?.process(models: response.data ?? [])
            }
        }, processModelsAfterBackend: { [weak self] response -> [Transaction]? in
            if let transactions: [Transaction] = response.data {
                self?.saveToDataBase(transactions: transactions)
            }
            return response.data
        }, processModelsAfterDataBase: nil)
    }
}
