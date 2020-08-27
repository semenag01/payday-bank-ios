//
//  SignUpModule.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import DataBase

class SignUpModule {
    static func assembly(sessionStorage: SessionStorable, window: UIWindow?) -> UIViewController {
        let router: SignUpRouter = SignUpRouter(window: window, sessionStorage: sessionStorage)
        let viewController: SignUpViewController = SignUpViewController()
        let presenter: SignUpPresenter = SignUpPresenter(router: router, viewController: viewController)
        let authGateway: AuthGateway = AuthGateway()
        let interactor: SignUpInteractor = SignUpInteractor(sessionStorage: sessionStorage, dataBaseStorage: SMDBStorageConfigurator.storage, authGateway: authGateway, output: presenter)
        presenter.interactor = interactor
        viewController.output = presenter
        return viewController
    }
}
