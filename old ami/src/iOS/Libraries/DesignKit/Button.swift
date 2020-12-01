//
//  Button.swift
//  Button
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

@IBDesignable
public class Button: UIButton {
    
    // MARK: - Inspectable
    
    @IBInspectable
    public var normalBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable
    public var disabledBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureUI()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        cornerRadius = 10.0
    }
    
    // MARK: - Public
    
    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        updateBackgroundColor()
    }
    
    // MARK: - Private
    
    private func updateBackgroundColor() {
        backgroundColor = isEnabled ? normalBackgroundColor : disabledBackgroundColor
    }
    
}
