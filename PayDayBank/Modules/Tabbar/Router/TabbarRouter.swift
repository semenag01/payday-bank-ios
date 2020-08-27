//
//  TabbarRouter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

protocol TabbarRouterInput {
    func didLogout()
}

class TabbarRouter: TabbarRouterInput, Router {
    private let window: UIWindow?
    private let sessionStorage: SessionStorable
    
    init(window: UIWindow?, sessionStorage: SessionStorable) {
        self.window = window
        self.sessionStorage = sessionStorage
    }
    
    deinit {
        print(#function, #file)
    }
    
    func didLogout() {
        let signInViewController: UIViewController = SignInModule.assembly(sessionStorage: sessionStorage, window: window)
        switchTo(viewController: signInViewController, for: window)
    }
}
