//
//  WeightAddInfoViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DesignKit
import UIUtils
import DataManager

protocol EditInfoCompleteDeligate: class {
    func completed()
}

class EditInfoViewController: UIViewController {

    @IBOutlet weak var weightField: TextField!
    @IBOutlet weak var dateTimeField: DatePickerField!
    @IBOutlet weak var button: Button!
    
    fileprivate var weightManager: WeightManager!
    fileprivate var errorParser: NetworkErrorParser!
    fileprivate var router: BaseRouter!
    
    weak var delegate: EditInfoCompleteDeligate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightManager = WeightManager()
        errorParser = NetworkErrorParser()
        errorParser.delegate = self
        router = BaseRouter(controller: self)
        
        weightField.delegate = self
        dateTimeField.delegate = self
        
        view.hideKeyboardWhenTapped()
        
        dateTimeField.datePicker.datePickerMode = .dateAndTime
        dateTimeField.datePicker.maximumDate = Date()
        dateTimeField.dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        
        validateForm()
    }

    @IBAction func adding(_ sender: Any) {
        guard let weightStr = weightField.text?.replacingOccurrences(of: ",", with: "."),
            let weight = Double(weightStr) else { return }
        let weighedAt = dateTimeField.date
        weightManager.save(amount: weight, weighedAt: weighedAt) { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.router.dismiss(aminated: true, completion: nil)
                }
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
    private func validateForm() {
        guard let weight = weightField.text,
            let date = dateTimeField.text else {
            button.isEnabled = false
            return
        }
        button.setEnabled(!weight.isEmpty && !date.isEmpty)
    }
    
}

// MARK: - NetworkErrorParserDelegate

extension EditInfoViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}

// MARK: - UITextFieldDelegate

extension EditInfoViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateForm()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateForm()
    }
    
}
