//
//  DashboardModule.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend
import DataBase

class DashboardModule {
    static func assembly(sessionStorage: SessionStorable) -> UIViewController {
        let transactionGateway: TransactionsGateway = TransactionsGateway(sessionStorage: sessionStorage)
        let dataFetcher: DataFetcher = DataFetcher(requests: transactionGateway)
        let viewController: DashboardViewController = DashboardViewController()
        let presenter: DashboardPresenter = DashboardPresenter(viewController: viewController)
        let interactor: DashboardInteractor = DashboardInteractor(dataFetcher: dataFetcher,
                                                                  output: presenter,
                                                                  dataBasetorage: SMDBStorageConfigurator.storage)
        presenter.interactor = interactor
        viewController.output = presenter
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
