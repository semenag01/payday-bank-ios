//
//  AccountModule.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend
import DataBase

class AccountModule {
    static func assembly(sessionStorage: SessionStorable, output: AccountModuleOutput) -> UIViewController {
        let transactionGateway: AccountsGateway = AccountsGateway(sessionStorage: sessionStorage)
        let dataFetcher: DataFetcher = DataFetcher(requests: transactionGateway)
        let viewController: AccountViewController = AccountViewController()
        let presenter: AccountPresenter = AccountPresenter(output: output, viewController: viewController)
        let interactor: AccountInteractor = AccountInteractor(dataFetcher: dataFetcher,
                                                              output: presenter,
                                                              sessionStorage: sessionStorage,
                                                              dataBasetorage: SMDBStorageConfigurator.storage)
        presenter.interactor = interactor
        viewController.output = presenter
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0.175999999, green: 0.7089999914, blue: 1, alpha: 1)
        return navigationController
    }
}
