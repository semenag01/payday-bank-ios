//
//  AccountPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend

class AccountPresenter<V: AccountViewInput>: Presenter<V> {
    
    var interactor: AccountInteractorInput?
    private var output: AccountModuleOutput
    
    init(output: AccountModuleOutput, viewController: V?) {
        self.output = output
        
        super.init(viewController: viewController)
    }
}

extension AccountPresenter: AccountViewOutput {
    func viewDidLoad() {
        interactor?.fetchData()
    }
    
    func logout() {
        interactor?.logout()
    }
}

extension AccountPresenter: AccountInteractorOutput {
    func didFetchData(_ models: [Account]) {
        let cellViewModels: [AccountCellViewModel] =  models.map {
            AccountCellViewModel(iban: $0.iban, type: $0.type, date: $0.dateCreated, active: $0.active)
        }
        let sectionViewModel: AccountSectionViewModel = AccountSectionViewModel(cells: cellViewModels)
        
        viewController?.update(with: [sectionViewModel])
    }
    
    func didLogout() {
        output.didLogout()
    }
}
