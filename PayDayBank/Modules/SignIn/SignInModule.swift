//
//  SignInModule.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import DataBase

class SignInModule {
    static func assembly(sessionStorage: SessionStorable, window: UIWindow?) -> UIViewController {
        let viewController: SignInViewController = SignInViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        let router: SignInRouter = SignInRouter(window: window,
                                                navigationController: navigationController,
                                                sessionStorage: sessionStorage)
        let presenter: SignInPresenter = SignInPresenter(router: router, viewController: viewController)
        let authGateway: AuthGateway = AuthGateway()
        let interactor: SignInInteractor = SignInInteractor(sessionStorage: sessionStorage, dataBaseStorage: SMDBStorageConfigurator.storage, authGateway: authGateway, output: presenter)
        presenter.interactor = interactor
        viewController.output = presenter
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0.175999999, green: 0.7089999914, blue: 1, alpha: 1)
        return navigationController
    }
}
