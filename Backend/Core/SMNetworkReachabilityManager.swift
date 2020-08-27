//
//  SMNetworkReachabilityManager.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Alamofire

public protocol SMNetworkReachabilityManagerProtocol {
    
    var isReachable: Bool { get }
    
    init(host: String)
    
    func startListening()
    func stopListening()
}


open class SMDefaultNetworkReachabilityManager: SMNetworkReachabilityManagerProtocol {
    
    public let networkReachabilityManager: NetworkReachabilityManager?
    
    public var isReachable: Bool {
        return networkReachabilityManager?.isReachable == true
    }
    
    public required init(host: String) {
        networkReachabilityManager = NetworkReachabilityManager(host: host)
    }
    
    open func startListening() {
        networkReachabilityManager?.startListening(onUpdatePerforming: { _ in })
    }
    
    open func stopListening() {
        networkReachabilityManager?.stopListening()
    }
}
