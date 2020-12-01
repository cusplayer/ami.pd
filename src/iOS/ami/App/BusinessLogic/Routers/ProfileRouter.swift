//
//  ProfileRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ProfileRouter: BaseRouter {
    
    func toEdit() {
        guard let selfController = controller as? ProfileViewController else { fatalError() }
        let controller = RegisterInfoFillViewControllerBuilder.build(state: .edition)
        controller.modalPresentationStyle = .formSheet
        controller.router = UpdateRegisterInfoFillRouter(controller: selfController)
        controller.delegate = selfController
        present(controller, animated: true)
    }
    
}
