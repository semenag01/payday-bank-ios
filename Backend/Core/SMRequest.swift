//
//  SMRequest.swift
//  Backend
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

public typealias SMRequestResponseBlock<T> = (SMResponse<T>) -> Void

open class SMResponseNode<T> {
    
    public let responseQueue: DispatchQueue
    public let responseBlock: SMRequestResponseBlock<T>
    
    public init(responseBlock aResponseBlock: @escaping SMRequestResponseBlock<T>, responseQueue aResponseQueue: DispatchQueue) {
        
        responseBlock = aResponseBlock
        responseQueue = aResponseQueue
    }
}


open class SMRequest<T> {
    
    deinit {
        print(#function + " - \(type(of: self))")
    }
    
    public init() { }
    
    open var tag: Int = 0
    
    public let defaultResponseQueue: DispatchQueue = DispatchQueue.main

    open var responseBlocks: [SMResponseNode<T>] = []
    open var executeAllResponseBlocksSync: Bool = false
        
    open func canExecute() -> Bool {
        
        return false
    }
    
    @discardableResult
    open func start() -> Self {
        
        retainSelf()
        
        return self
    }
    
    @discardableResult
    open func startWithResponseBlockInMainQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock<T>) -> Self {
        
        return addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.main).start()
    }

    @discardableResult
    open func startWithResponseBlockInGlobalQueue(responseBlock aResponseBlock: @escaping SMRequestResponseBlock<T>) -> Self {
        
        return addResponseBlock(aResponseBlock, responseQueue: DispatchQueue.global()).start()
    }

    open func isExecuting() -> Bool {
        
        return false
    }
    
    open func cancel() {
        
    }
    
    open func isCancelled() -> Bool {
        
        return false
    }
    
    open func isFinished() -> Bool {
        
        return false
    }
    
    @discardableResult
    open func addResponseBlock(_ aResponseBlock: @escaping SMRequestResponseBlock<T>, responseQueue aResponseQueue: DispatchQueue) -> Self {
        
        responseBlocks.append(SMResponseNode(responseBlock: aResponseBlock, responseQueue: aResponseQueue))
        
        return self
    }

    open func addResponseBlockDefaultResponseQueue(_ aResponseBlock: @escaping SMRequestResponseBlock<T>) -> SMRequest {
        
        return addResponseBlock(aResponseBlock, responseQueue: defaultResponseQueue)
    }

    open func clearAllResponseBlocks() {
        
        responseBlocks.removeAll()
    }
    
    open func executeAllResponseBlocks(response aResponse: SMResponse<T>) {
        if executeAllResponseBlocksSync {
            executeAllResponseBlocksSynchronously(response: aResponse)
        } else {
            executeAllResponseBlocksAsynchronously(response: aResponse)
        }
    }
    
    open func executeAllResponseBlocksAsynchronously(response aResponse: SMResponse<T>) {
        
        for node: SMResponseNode in responseBlocks {
            
            node.responseQueue.async {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }

    open func executeAllResponseBlocksSynchronously(response aResponse: SMResponse<T>) {
        
        for node: SMResponseNode in responseBlocks {
            
            node.responseQueue.sync {
                node.responseBlock(aResponse)
            }
        }
        
        releaseSelf()
    }
    
    
    // MARK: - Retain
    
    fileprivate var _self: SMRequest?
    func retainSelf() {
        _self = self
    }
    
    func releaseSelf() {
        _self = nil
    }
}
