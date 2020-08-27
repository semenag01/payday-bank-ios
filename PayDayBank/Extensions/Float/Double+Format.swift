//
//  Double+Format.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
