//
//  TabbarPresenter.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

class TabbarPresenter: Presenter<TabbarController>, AccountModuleOutput {
    private var router: TabbarRouterInput
    
    init(router: TabbarRouterInput, viewController: TabbarController?) {
        self.router = router
        
        super.init(viewController: viewController)
    }
    
    func didLogout() {
        router.didLogout()
    }    
}
