//
//  DatePickerField.swift
//  DesignKit
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

private let toolbarHeight: CGFloat = 35

@IBDesignable
public class DatePickerField: TextField {
    
    // MARK: - Properties
    
    public var date: Date {
        get {
            datePicker.date
        }
        set {
            datePicker.date = newValue
            text = dateFormatter.string(from: newValue)
        }
    }
    
    public var datePicker: UIDatePicker! {
        didSet {
            inputView = datePicker
        }
    }
    
    public var dateFormatter: DateFormatter!
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        dateFormatter = DateFormatter()
        configureDatePicker()
        configureToolbar()
        configureDateFormatter()
    }
    
    // MARK: - Configure
    
    private func configureDatePicker() {
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
    }
    
    private func configureToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: toolbarHeight))

        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputAccessoryView = toolBar
    }
    
    private func configureDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    // MARK: - Events
    
    @objc
    func dateChanged() {
        setText()
    }
    
    @objc
    func donePressed() {
        setText()
        endEditing(true)
    }
    
    // MARK: - Private
    
    private func setText() {
        text = dateFormatter.string(from: datePicker.date)
    }
    
}
