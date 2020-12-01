//
//  WaterManagerRouter.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class WaterManagerRouter: BaseRouter {
    
    func toHistory() {
        let registerVC = WaterHistoryViewControllerBuilder.build()
        push(registerVC, animated: true)
    }
    
}
