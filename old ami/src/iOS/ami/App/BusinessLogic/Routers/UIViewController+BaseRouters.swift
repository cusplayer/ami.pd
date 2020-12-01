//
//  UIViewController+BaseRouters.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func toAuth() {
        let baseRouter = BaseRouter(controller: self)
        let registerVC = RegisterViewControllerBuilder.build()
        var transitionOptions = UIWindow.TransitionOptions(direction: .fade, style: .easeOut)
        transitionOptions.duration = 0.5
        baseRouter.setRoot(registerVC, transitionOptions: transitionOptions)
    }
    
    func toMain() {
        let baseRouter = BaseRouter(controller: self)
        let mainVC = MainViewController()
        var transitionOptions = UIWindow.TransitionOptions(direction: .fade, style: .easeOut)
        transitionOptions.duration = 0.5
        baseRouter.setRoot(mainVC, transitionOptions: transitionOptions)
    }
    
}
