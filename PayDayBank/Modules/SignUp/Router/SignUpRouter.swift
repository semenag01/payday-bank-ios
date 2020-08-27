//
//  SignUpRouter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

protocol SignUpRouterInput {
    func didSignUp()
}

class SignUpRouter: Router, SignUpRouterInput {
    private let window: UIWindow?
    private let sessionStorage: SessionStorable
    
    init(window: UIWindow?, sessionStorage: SessionStorable) {
        self.window = window
        self.sessionStorage = sessionStorage
    }
    
    deinit {
        print(#function, #file)
    }
    
    func didSignUp() {
        let tabbarController: UIViewController = TabbarModule.assembly(sessionStorage: sessionStorage, window: window)
        switchTo(viewController: tabbarController, for: window)
    }
}
