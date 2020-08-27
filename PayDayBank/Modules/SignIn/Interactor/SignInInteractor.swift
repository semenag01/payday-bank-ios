//
//  SignInInteractor.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import DataBase

class SignInInteractor {
    private let sessionStorage: SessionStorable
    private let dataBaseStorage: DataBaseStorable
    private let authGateway: AuthRequestable
    private weak var output: SignInInteractorOutput?
    
    init(sessionStorage: SessionStorable,
         dataBaseStorage: DataBaseStorable,
         authGateway: AuthRequestable,
         output: SignInInteractorOutput) {
        self.sessionStorage = sessionStorage
        self.dataBaseStorage = dataBaseStorage
        self.authGateway = authGateway
        self.output = output
    }
    
    deinit {
        print(#function, #file)
    }
    
    private func process(model: User) {
        dataBaseStorage.saveAndWait(block: { context in
            let boUser: BOUser = BOUser(context: context)
            boUser.identifier = model.id
        }, completion: nil)
        
        sessionStorage.loginWithSession(.init(userId: model.id))
        output?.didSignIn()
    }
}

extension SignInInteractor: SignInInteractorInput {
    func signInWith(email: String, password: String) {
        let signInModel: SignInModel = SignInModel(email: email, password: password)
        authGateway.signInRequest(with: signInModel).startWithResponseBlockInMainQueue { [weak self] response in
            guard response.isSuccess,
                let user: User = response.data else {
                    self?.output?.fail(with: response.error)
                    return
            }
            
            self?.process(model: user)
        }
    }
}
