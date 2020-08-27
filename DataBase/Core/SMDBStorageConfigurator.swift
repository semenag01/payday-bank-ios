//
//  SMDBStorageConfigurator.swift
//  DataBase
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

open class SMDBStorageConfigurator {
    
    public static var storageType: SMDBStorage.Type = SMDBStorage.self
    public static var storage: SMDBStorage = SMDBStorageConfigurator.storageType.init()
    
    public static func registerStorageClass(_ storageType: SMDBStorage.Type) {
        
        self.storageType = storageType
        storage = storageType.init()
    }
}
