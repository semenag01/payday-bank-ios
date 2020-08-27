//
//  AuthRequestable.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend

protocol AuthRequestable {
    func signInRequest(with model: SignInModel) -> SMRequest<User>
    func signUpRequest(with model: SignUpModel) -> SMRequest<User>
}
