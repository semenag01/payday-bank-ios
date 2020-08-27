//
//  SignInRouter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class SignInRouter: Router, SignInRouterInput {
    private let window: UIWindow?
    private let sessionStorage: SessionStorable
    private weak var navigationController: UINavigationController?
    
    
    init(window: UIWindow?,
         navigationController: UINavigationController,
         sessionStorage: SessionStorable) {
        self.window = window
        self.navigationController = navigationController
        self.sessionStorage = sessionStorage
    }
    
    deinit {
        print(#function, #file)
    }
    
    func didSignIn() {
        let tabbarController: UIViewController = TabbarModule.assembly(sessionStorage: sessionStorage, window: window)
        switchTo(viewController: tabbarController, for: window)
    }
    
    func showSignupModule() {
        let signUpViewController: UIViewController = SignUpModule.assembly(sessionStorage: sessionStorage, window: window)
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
}
