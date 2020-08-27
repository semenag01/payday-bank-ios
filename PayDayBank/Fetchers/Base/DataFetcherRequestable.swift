//
//  DataFetcherRequestable.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend

protocol DataFetcherRequestable {
    associatedtype T
    
    func getRequest() -> SMRequest<T>?
    func getDateBaseRequest() -> SMRequest<T>?
}

extension DataFetcherRequestable {
    func getRequest() -> SMRequest<T>? {
        return nil
    }
    
    func getDateBaseRequest() -> SMRequest<T>? {
        return nil
    }
}
