//
//  TabbarModule.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class TabbarModule {
    static func assembly(sessionStorage: SessionStorable, window: UIWindow?) -> UIViewController {
        let router: TabbarRouter = TabbarRouter(window: window, sessionStorage: sessionStorage)
        let tabbarController: TabbarController = TabbarController()
        let presenter: TabbarPresenter = TabbarPresenter(router: router, viewController: tabbarController)
        tabbarController.presenter = presenter
        tabbarController.viewControllers = [
            assemblyDashboardModule(sessionStorage: sessionStorage),
            assemblyTransactionsModule(sessionStorage: sessionStorage),
            assemblyAccountModule(sessionStorage: sessionStorage, output: presenter)
        ]
        tabbarController.tabBar.tintColor = #colorLiteral(red: 0.175999999, green: 0.7089999914, blue: 1, alpha: 1)
        return tabbarController
    }
    
    private static func assemblyDashboardModule(sessionStorage: SessionStorable) -> UIViewController {
        let dashboardViewController: UIViewController = DashboardModule.assembly(sessionStorage: sessionStorage)
        dashboardViewController.tabBarItem = .init(title: "Dashboard", image: UIImage(systemName: "calendar"), tag: 0)
        return dashboardViewController
    }
    
    private static func assemblyTransactionsModule(sessionStorage: SessionStorable) -> UIViewController {
        let transactionsViewController: UIViewController = TransactionsModule.assembly(sessionStorage: sessionStorage)
        transactionsViewController.tabBarItem = .init(title: "Transactions", image: UIImage(systemName: "list.dash"), tag: 0)
        return transactionsViewController
    }
    
    private static func assemblyAccountModule(sessionStorage: SessionStorable, output: AccountModuleOutput) -> UIViewController {
        let accountViewController: UIViewController = AccountModule.assembly(sessionStorage: sessionStorage, output: output)
        accountViewController.tabBarItem = .init(title: "Account", image: UIImage(systemName: "person"), tag: 0)
        return accountViewController
    }
}
