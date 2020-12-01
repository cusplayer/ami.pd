//
//  UITableView+ReusableCell.swift
//  UIUtils
//
//  Created by Artem Kufaev on 25.04.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: ReusableCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }

        return cell
    }

}
