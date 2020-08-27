//
//  Account.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

public struct Account: Codable {
    public let id: Int64
    public let customerId: Int64
    public let iban: String
    public let type: String
    public let dateCreated: Date
    public let active: Bool
    
    public init(id: Int64,
                customerId: Int64,
                iban: String?,
                type: String?,
                dateCreated: Date?,
                active: Bool?) {
        self.id = id
        self.customerId = customerId
        self.iban = iban ?? ""
        self.type = type ?? ""
        self.dateCreated = dateCreated ?? Date()
        self.active = active ?? false
    }
}
