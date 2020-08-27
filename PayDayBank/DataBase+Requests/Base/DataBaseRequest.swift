//
//  DataBaseRequest.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Backend
import CoreData
import DataBase

class DataBaseRequest<F: NSFetchRequestResult, T>: SMRequest<T> {
    private let storage: DataBaseStorable
    private let fetchRequest: NSFetchRequest<F>
    private var cancelled: Bool = false
    private var executing: Bool = false

    init(storage: DataBaseStorable,
         fetchRequest: NSFetchRequest<F>) {
        self.storage = storage
        self.fetchRequest = fetchRequest
    }
    
    // MARK: Request execute
    
    override func canExecute() -> Bool {
        return true
    }
    
    override func start() -> Self {
        cancelled = false
        executing = true
        
        storage.defaultContext(block: { [weak self] aContext in
            if let self: DataBaseRequest = self {
                if self.isCancelled() {
                    self.executing = false
                    let response: SMResponse = SMResponse<T>()
                    response.isCancelled = true
                    response.isSuccess = true
                    
                    if self.executeAllResponseBlocksSync {
                        self.executeAllResponseBlocksSynchronously(response: response)
                    } else {
                        self.executeAllResponseBlocks(response: response)
                    }
                } else {
                    let response: SMResponse = self.executeRequest(request: self.fetchRequest, inContext: aContext)
                    response.isSuccess = true
                    self.executing = false
                    if self.executeAllResponseBlocksSync {
                        self.executeAllResponseBlocksSynchronously(response: response)
                    } else {
                        self.executeAllResponseBlocks(response: response)
                    }
                }
            }
        })
        return self
    }
    
    
    // MARK: 

    func executeRequest(request aRequest: NSFetchRequest<F>, inContext aContext: NSManagedObjectContext) -> SMResponse<T> {
        var result: [F] = []
        do {
            result = try aContext.fetch(aRequest)
            return process(result: .success(result))
        } catch {
            return process(result: .failure(error))
        }
    }
    
    override func cancel() {
        cancelled = true
    }
    
    override func isExecuting() -> Bool {
        return executing
    }
    
    override func isCancelled() -> Bool {
        return cancelled
    }
    
    func process(result: Result<[F], Error>) -> SMResponse<T> {
        return SMResponse<T>()
    }
}
