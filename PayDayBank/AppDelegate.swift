//
//  AppDelegate.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import Backend
import DataBase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let sessionStorage: SessionStorable = SessionService(dataBaseStorage: SMDBStorageConfigurator.storage)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SMGatewayConfigurator.shared.configure(with: URL(string: "http://localhost:3000"))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        updateRootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func updateRootViewController() {
        if sessionStorage.isLogined {
            window?.rootViewController = TabbarModule.assembly(sessionStorage: sessionStorage, window: window)
        } else {
            window?.rootViewController = SignInModule.assembly(sessionStorage: sessionStorage, window: window)
        }
    }
}
