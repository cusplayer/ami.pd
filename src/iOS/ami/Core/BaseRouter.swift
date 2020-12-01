//
//  BaseRouter.swift
//  ami
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func show(_ controller: UIViewController, sender: Any?) {
        self.controller.show(controller, sender: sender)
    }
    
    func present(_ controller: UIViewController, animated: Bool) {
        self.controller.present(controller, animated: animated)
    }
    
    func dismiss(aminated: Bool, completion: (() -> Void)?) {
        self.controller.dismiss(animated: aminated, completion: completion)
    }
    
    func push(_ controller: UIViewController, animated: Bool) {
        self.controller.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.controller.navigationController?.popViewController(animated: animated)
    }
    
    func setRoot(_ controller: UIViewController, transitionOptions: UIWindow.TransitionOptions? = nil) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }

        if let transitionOptions = transitionOptions {
            window.setRootViewController(controller,
                                         options: transitionOptions)
        } else {
            window.setRootViewController(controller)
        }
    }
    
}
