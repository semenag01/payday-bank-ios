//
//  SignUpPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend

class SignUpPresenter<V: SignUpViewInput>: Presenter<V> {
    
    var interactor: SignUpInteractorInput?
    private var router: SignUpRouterInput
    
    init(router: SignUpRouterInput, viewController: V?) {
        self.router = router
        
        super.init(viewController: viewController)
    }
}

extension SignUpPresenter: SignUpViewOutput {
    func signUpWith(firstName: String?,
                    lastName: String?,
                    gender: String?,
                    email: String?,
                    password: String?,
                    dob: String?,
                    phone: String?) {
        guard let firstName: String = firstName,
            !firstName.isEmpty,
            let lastName: String = lastName,
            !lastName.isEmpty,
            let gender: String = gender,
            !gender.isEmpty,
            let email: String = email,
            !email.isEmpty,
            let password: String = password,
            !password.isEmpty,
            let dob: String = dob,
            !dob.isEmpty,
            let phone: String = phone,
            !phone.isEmpty else {
                viewController?.showError(text: "Fields not valid")
                return
        }
        
        viewController?.showActivity()
        interactor?.signUpWith(firstName: firstName,
                               lastName: lastName,
                               gender: gender,
                               email: email,
                               password: password,
                               dob: dob,
                               phone: phone)
    }
}

extension SignUpPresenter: SignUpInteractorOutput {
    func fail(with error: Error?) {
        viewController?.hideActivity()
        viewController?.showError(text: error?.localizedDescription)
    }
    
    func didSignUp() {
        router.didSignUp()
    }
}
