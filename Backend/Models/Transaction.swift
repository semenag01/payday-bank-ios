//
//  Transaction.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

public struct Transaction: Codable {
    public let id: Int64
    public let date: Date
    public let category: String
    public let amount: String
    public let vendor: String
    
    public var amountValue: Double {
        return Double(amount) ?? 0
    }
    
    public init(id: Int64,
                date: Date?,
                category: String?,
                amount: String?,
                vendor: String?) {
        self.id = id
        self.date = date ?? Date()
        self.category = category ?? ""
        self.amount = amount ?? ""
        self.vendor = vendor ?? ""
    }
}
