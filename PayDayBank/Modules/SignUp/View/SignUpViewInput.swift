//
//  SignUpViewInput.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

protocol SignUpViewInput: ViewInput {
    func showError(text: String?)
    func showActivity()
    func hideActivity()
}
