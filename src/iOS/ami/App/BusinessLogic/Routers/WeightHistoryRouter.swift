//
//  WeightHistoryRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class WeightHistoryRouter: BaseRouter {
    
    func toEditor(with state: EditInfoViewController.State) {
        guard let selfController = self.controller as? EditInfoCompleteDeligate else { fatalError() }
        let controller = EditInfoViewController()
        controller.state = state
        controller.delegate = selfController
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
}
