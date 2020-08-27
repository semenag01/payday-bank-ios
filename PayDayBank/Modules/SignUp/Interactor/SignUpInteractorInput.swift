//
//  SignUpInteractorInput.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

protocol SignUpInteractorInput {
    func signUpWith(firstName: String,
                    lastName: String,
                    gender: String,
                    email: String,
                    password: String,
                    dob: String,
                    phone: String)
}
