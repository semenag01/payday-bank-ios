//
//  Router.swift
//  PayDayBank
//
//  Created by Developer on 15.07.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

protocol Router {
    func switchTo(viewController: UIViewController, for window: UIWindow?)
}

extension Router {
    func switchTo(viewController: UIViewController, for window: UIWindow?) {
        var snapShot: UIView?
        
        if window?.isKeyWindow == true {
            snapShot = window?.snapshotView(afterScreenUpdates: false)
            if let snapShot: UIView = snapShot {
                window?.addSubview(snapShot)
            }
        }
        
        dismiss(vc: viewController) {
            window?.rootViewController = viewController
            if let snapShot: UIView = snapShot {
                window?.bringSubviewToFront(snapShot)
                UIView.animate(withDuration: 0.3, animations: {
                    snapShot.layer.opacity = 0
                }, completion: { _ in
                    DispatchQueue.main.async {
                        snapShot.removeFromSuperview()
                    }
                })
            }
        }
    }
    
    func dismiss(vc aVc: UIViewController, completion: @escaping (() -> Void)) {
        if aVc.presentedViewController != nil {
            dismiss(vc: aVc, completion: {
                aVc.dismiss(animated: false, completion: completion)
            })
        } else {
            completion()
        }
    }
}
