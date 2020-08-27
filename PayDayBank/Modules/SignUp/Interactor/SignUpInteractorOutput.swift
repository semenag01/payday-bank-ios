//
//  SignUpInteractorOutput.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

protocol SignUpInteractorOutput: class {
    func fail(with error: Error?)
    func didSignUp()
}
