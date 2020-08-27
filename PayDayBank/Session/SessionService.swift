//
//  SessionServie.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation
import DataBase

struct SessionManagerUDKeys {
    static let session: String = "AppManagerUDKeysSession"
}

class SessionService: SessionStorable {
    private let propertyListEncoder: PropertyListEncoder = PropertyListEncoder()
    private let propertyListDecoder: PropertyListDecoder = PropertyListDecoder()
    
    private(set) var session: Session?
    private let dataBaseStorage: DataBaseStorable
    
    var user: BOUser? {
        if let userID: Int64 = session?.userId {
            let user: BOUser? = BOUser.objectByID(userID)
            return user
        } else {
            return nil
        }
    }
    
    var isLogined: Bool {
        return session != nil
    }
    
    init(dataBaseStorage: DataBaseStorable) {
        self.dataBaseStorage = dataBaseStorage
        guard let data: Data = UserDefaults.standard.data(forKey: SessionManagerUDKeys.session) else { return }
        
        do {
            session = try propertyListDecoder.decode(Session.self, from: data)
        } catch {
            print("---- fetching session error happened")
        }
    }
    
    func loginWithSession(_ aSession: Session) {
        session = aSession
        saveSession()
    }
    
    func logout() {
        removeSession()
        dataBaseStorage.clear()
    }
    
    private func saveSession() {
        if session != nil {
            do {
                let data: Data = try propertyListEncoder.encode(session)
                UserDefaults.standard.set(data, forKey: SessionManagerUDKeys.session)
            } catch {
                print("---- error encoding session happened")
            }
        } else {
            removeSession()
        }
    }
    
    private func removeSession() {
        session = nil
        let ud: UserDefaults = UserDefaults.standard
        ud.removeObject(forKey: SessionManagerUDKeys.session)
    }
}
