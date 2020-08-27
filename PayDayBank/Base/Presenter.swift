//
//  Presenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class Presenter<V: ViewInput> {
    
    weak var viewController: V?
    
    init(viewController: V?) {
        self.viewController = viewController
    }
    
    deinit {
        print(#function, #file)
    }
}
