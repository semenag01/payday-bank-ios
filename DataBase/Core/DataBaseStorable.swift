//
//  DataBaseStorable.swift
//  DataBase
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import CoreData

public typealias SMStorageContextBlock = (NSManagedObjectContext) -> Void
public typealias SMStorageVoidBlock = () -> Void

public protocol DataBaseStorable {
    func save(block aBlock: @escaping SMStorageContextBlock, completion aCompletion: SMStorageVoidBlock?)
    func saveAndWait(block aBlock: SMStorageContextBlock, completion aCompletion: SMStorageVoidBlock?)
    func defaultContext(block aBlock: @escaping SMStorageContextBlock)
    func clear()
}
