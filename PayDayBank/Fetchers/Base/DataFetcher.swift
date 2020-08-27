//
//  DataFetcher.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend

class DataFetcher<R: DataFetcherRequestable>: Fetcher {
    open var isFetchOnlyFromDataBase: Bool = false
    open var isFetchFromDataBaseWhenGatewayRequestFailed: Bool = true
    open var isFetchFromDataBaseWhenGatewayRequestSuccess: Bool = false
    open var isFetchFromDataBaseIfGatewayRequestIsNil: Bool = false
    
    private let requests: R
    private let callbackQueue: DispatchQueue
    private var fetchCallback: FetchCallback<R.T>?
    private var processModelsAfterBackend: ProcessCallback<R.T>?
    private var processModelsAfterDataBase: ProcessCallback<R.T>?
    private var preparedRequest: SMRequest<R.T>?
    
    init(requests: R,
         callbackQueue: DispatchQueue = .global()) {
        self.requests = requests
        self.callbackQueue = callbackQueue
    }
    
    // MARK: Request
    
    private var _request: SMRequest<R.T>?
    private var request: SMRequest<R.T>? {
        set {
            if _request !== newValue {
                cancelFetching()
                _request = newValue
                _request?.addResponseBlock({ [weak self] response in
                    guard let self: DataFetcher = self else { return }
                    
                    if newValue?.tag == 0 {
                        let success: Bool = response.isSuccess
                        if success {
                            let processedModels: R.T? = self.processModelsAfterBackend?(response)
                            response.data = processedModels ?? response.data
                            if self.isFetchFromDataBaseWhenGatewayRequestSuccess {
                                self.request = self.requests.getDateBaseRequest()
                                self.request?.tag = 1
                                if self.request != nil {
                                    self.request?.start()
                                } else {
                                    let processedModels: R.T? = self.processModelsAfterBackend?(response)
                                    response.data = processedModels ?? response.data
                                    
                                    if let fetchCallback: FetchCallback = self.fetchCallback {
                                        fetchCallback(response)
                                    }
                                }
                            } else {
                                if let fetchCallback: FetchCallback = self.fetchCallback {
                                    fetchCallback(response)
                                }
                            }
                        } else if self.isFetchFromDataBaseWhenGatewayRequestFailed && !response.isCancelled {
                            self.request = self.requests.getDateBaseRequest()
                            self.request?.tag = 1
                            if self.request != nil {
                                self.request?.start()
                            } else {
                                if let fetchCallback: FetchCallback = self.fetchCallback {
                                    fetchCallback(response)
                                }
                            }
                        } else {
                            if let fetchCallback: FetchCallback = self.fetchCallback {
                                fetchCallback(response)
                            }
                        }
                        
                    } else {
                        let processedModels: R.T? = self.processModelsAfterDataBase?(response)
                        response.data = processedModels ?? response.data
                        
                        if let fetchCallback: FetchCallback = self.fetchCallback {
                            fetchCallback(response)
                        }
                    }
                    }, responseQueue: callbackQueue)
            }
        }
        
        get { return _request }
    }
    
    open func getPreparedRequest() -> SMRequest<R.T>? {
        var newRequest: SMRequest<R.T>?
        
        if !isFetchOnlyFromDataBase {
            if SMGatewayConfigurator.shared.isInternetReachable {
                newRequest = requests.getRequest()
                if newRequest == nil && isFetchFromDataBaseIfGatewayRequestIsNil {
                    newRequest = requests.getDateBaseRequest()
                    newRequest?.tag = 1
                }
            } else {
                newRequest = requests.getDateBaseRequest()
                newRequest?.tag = 1
            }
        } else {
            newRequest = requests.getDateBaseRequest()
            newRequest?.tag = 1
        }
        return newRequest
    }
    
    
    // MARK: Fetch
    func fetchData(withCallback fetchCallback: @escaping FetchCallback<R.T>,
                   processModelsAfterBackend: ProcessCallback<R.T>?,
                   processModelsAfterDataBase: ProcessCallback<R.T>?) {
        self.fetchCallback = fetchCallback
        self.processModelsAfterBackend = processModelsAfterBackend
        self.processModelsAfterDataBase = processModelsAfterDataBase
        
        if preparedRequest == nil {
            preparedRequest = getPreparedRequest()
        }
        
        request = preparedRequest
        preparedRequest = nil
        
        request?.start()
    }
    
    func cancelFetching() {
        request?.cancel()
    }
}
