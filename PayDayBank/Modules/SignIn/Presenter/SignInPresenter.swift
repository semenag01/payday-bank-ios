//
//  SignInPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend

class SignInPresenter<V: SignInViewInput>: Presenter<V> {
    
    var interactor: SignInInteractorInput?
    private var router: SignInRouterInput
    
    init(router: SignInRouterInput, viewController: V?) {
        self.router = router
        
        super.init(viewController: viewController)
    }
}

extension SignInPresenter: SignInViewOutput {
    func onSignUp() {
        router.showSignupModule()
    }
    
    func signInWith(email: String?, password: String?) {
        guard let email: String = email,
            !email.isEmpty,
            let password: String = password,
            !password.isEmpty else {
                viewController?.showError(text: "Fields not valid")
                return
        }
        
        viewController?.showActivity()
        interactor?.signInWith(email: email, password: password)
    }
}

extension SignInPresenter: SignInInteractorOutput {
    func fail(with error: Error?) {
        viewController?.hideActivity()
        viewController?.showError(text: error?.localizedDescription)
    }
    
    func didSignIn() {
        router.didSignIn()
    }
}
