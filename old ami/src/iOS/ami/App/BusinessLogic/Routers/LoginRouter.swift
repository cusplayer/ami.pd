//
//  LoginRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class LoginRouter: BaseRouter {
    
    func toRegister() {
        let registerVC = RegisterViewControllerBuilder.build()
        var transitionOptions = UIWindow.TransitionOptions(direction: .toLeft, style: .easeOut)
        transitionOptions.duration = 0.3
        setRoot(registerVC, transitionOptions: transitionOptions)
    }
    
}
