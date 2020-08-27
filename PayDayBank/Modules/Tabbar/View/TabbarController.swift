//
//  TabbarController.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, ViewInput {
    var presenter: TabbarPresenter?
    
    deinit {
        print(#function, #file)
    }
}
