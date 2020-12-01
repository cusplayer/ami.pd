//
//  ConfigurableCell.swift
//  UIUtils
//
//  Created by Artem Kufaev on 25.04.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

public protocol ConfigurableCell: ReusableCell {
    associatedtype ViewModel

    func configure(_ viewModel: ViewModel, at indexPath: IndexPath)
}
