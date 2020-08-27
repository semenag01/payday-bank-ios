//
//  SMResponse.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

open class SMResponse<T> {
    
    open var isSuccess: Bool = false
    open var error: Error?
    open var data: T?
    open var isCancelled: Bool = false
    
    public init() { }
}
