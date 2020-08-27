//
//  SignUpInteractor.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import DataBase

class SignUpInteractor {
    private let sessionStorage: SessionStorable
    private let dataBaseStorage: DataBaseStorable
    private let authGateway: AuthRequestable
    private weak var output: SignUpInteractorOutput?
    
    init(sessionStorage: SessionStorable,
         dataBaseStorage: DataBaseStorable,
         authGateway: AuthRequestable,
         output: SignUpInteractorOutput) {
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
        output?.didSignUp()
    }
}

extension SignUpInteractor: SignUpInteractorInput {
    func signUpWith(firstName: String,
                    lastName: String,
                    gender: String,
                    email: String,
                    password: String,
                    dob: String,
                    phone: String) {
        let signUpModel: SignUpModel = SignUpModel(firstName: firstName,
                                                   lastName: lastName,
                                                   gender: gender,
                                                   email: email,
                                                   password: password,
                                                   dob: dob,
                                                   phone: phone)
        authGateway.signUpRequest(with: signUpModel).startWithResponseBlockInMainQueue { [weak self] response in
            guard response.isSuccess,
                let user: User = response.data else {
                    self?.output?.fail(with: response.error)
                    return
            }
            
            self?.process(model: user)
        }
    }
}
