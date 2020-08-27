//
//  AccountInteractor.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import DataBase

class AccountInteractor<F: Fetcher> where F.T == [Account] {
    private let dataFetcher: F
    private weak var output: AccountInteractorOutput?
    private let sessionStorage: SessionStorable
    private let dataBasetorage: DataBaseStorable
    
    init(dataFetcher: F,
         output: AccountInteractorOutput,
         sessionStorage: SessionStorable,
         dataBasetorage: DataBaseStorable) {
        self.dataFetcher = dataFetcher
        self.output = output
        self.sessionStorage = sessionStorage
        self.dataBasetorage = dataBasetorage
    }
    
    deinit {
        print(#function, #file)
    }
    
    private func saveToDataBase(accounts: [Account]) {
        dataBasetorage.save(block: { context in
            accounts.forEach {
                let boTransaction: BOAccount = BOAccount.objectByID($0.id) ?? BOAccount(context: context)
                boTransaction.identifier = $0.id
                boTransaction.customerId = $0.customerId
                boTransaction.iban = $0.iban
                boTransaction.type = $0.type
                boTransaction.dateCreated = $0.dateCreated
                boTransaction.active = $0.active
            }
        }, completion: nil)
    }
}

extension AccountInteractor: AccountInteractorInput {
    func fetchData() {
        dataFetcher.fetchData(withCallback: { [weak self] response in
            DispatchQueue.main.async {
                self?.output?.didFetchData(response.data ?? [])
            }
        }, processModelsAfterBackend: { [weak self] response -> [Account]? in
            if let accounts: [Account] = response.data {
                self?.saveToDataBase(accounts: accounts)
            }
            
            return response.data
        }, processModelsAfterDataBase: nil)
    }
    
    func logout() {
        sessionStorage.logout()
        output?.didLogout()
    }
}
