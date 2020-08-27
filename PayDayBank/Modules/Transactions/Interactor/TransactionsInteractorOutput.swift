//
//  TransactionsInteractorOutput.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
import Backend

protocol TransactionsInteractorOutput: class {
    func didFetchData(_ models: [[Transaction]])
}
