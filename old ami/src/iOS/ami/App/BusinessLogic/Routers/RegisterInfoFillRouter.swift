//
//  RegisterInfoFillRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

protocol IRegisterInfoFillRouter: BaseRouter {
    func toNext()
    func goBack()
}

class InputRegisterInfoFillRouter: BaseRouter, IRegisterInfoFillRouter {
    
    func toNext() {
        controller.toMain()
    }
    
    func goBack() {
        pop(animated: true)
    }
    
}

class UpdateRegisterInfoFillRouter: BaseRouter, IRegisterInfoFillRouter {
    
    func toNext() {
        dismiss(aminated: true, completion: nil)
    }
    
    func goBack() {
        dismiss(aminated: true, completion: nil)
    }
    
}
