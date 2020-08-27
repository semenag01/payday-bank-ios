//
//  SMGatewayConfigurator.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

open class SMGatewayConfigurator {
    
    public static let shared: SMGatewayConfigurator = SMGatewayConfigurator()
        
    open private(set) var defaultParameters: [String: AnyObject] = [:]
    open private(set) var defaultHeaders: [String: String] = [:]
    open private(set) var baseUrl: URL?
    open private(set) var networkReachabilityManager: SMNetworkReachabilityManagerProtocol?
    
    open var isInternetReachable: Bool {
        
        let result: Bool = networkReachabilityManager?.isReachable == true
        
        return result
    }
    
    private init() { }
    
    open func configure(with baseUrl: URL?, networkReachabilityManager: SMNetworkReachabilityManagerProtocol? = nil) {
        
        self.baseUrl = baseUrl
        
        if let networkReachabilityManager: SMNetworkReachabilityManagerProtocol = networkReachabilityManager {
            
            self.networkReachabilityManager = networkReachabilityManager
            
        } else if self.networkReachabilityManager == nil,
            let host: String = baseUrl?.host {
            
            self.networkReachabilityManager = SMDefaultNetworkReachabilityManager(host: host)
        }
        
        self.networkReachabilityManager?.startListening()
    }
    
    open func set(networkReachabilityManager: SMNetworkReachabilityManagerProtocol) {
        
        self.networkReachabilityManager = networkReachabilityManager
        networkReachabilityManager.startListening()
    }
        
    open func setHTTPHeader(value aValue: String?, key aKey: String) {
        
        defaultHeaders[aKey] = aValue
    }
    
    open func removeHTTPHeader(forKey key: String) {
        
        defaultHeaders.removeValue(forKey: key)
    }
    
    open func removeAllHTTPHeaders() {
        
        defaultHeaders.removeAll()
    }
    
    open func setDefaulParameter(value aValue: AnyObject?, key aKey: String) {
        
        defaultParameters[aKey] = aValue
    }
    
    open func removeDefaulParameter(forKey key: String) {
        
        defaultParameters.removeValue(forKey: key)
    }
    
    open func removeAllDefaulParameter() {
        
        defaultParameters.removeAll()
    }
}
