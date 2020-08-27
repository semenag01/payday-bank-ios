//
//  Fetcher.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend

public typealias FetchCallback<T> = (SMResponse<T>) -> Void
public typealias ProcessCallback<T> = (SMResponse<T>) -> T?

public protocol Fetcher {
    associatedtype T
    
    func fetchData(withCallback aFetchCallback: @escaping FetchCallback<T>,
                   processModelsAfterBackend: ProcessCallback<T>?,
                   processModelsAfterDataBase: ProcessCallback<T>?)
    func cancelFetching()
}
