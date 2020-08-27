//
//  SessionStorable.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import DataBase

protocol SessionStorable {
    var isLogined: Bool { get }
    var user: BOUser? { get }
    func loginWithSession(_ aSession: Session)
    func logout()
}
