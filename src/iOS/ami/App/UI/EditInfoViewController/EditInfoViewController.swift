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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightField: TextField!
    @IBOutlet weak var dateTimeField: DatePickerField!
    @IBOutlet weak var button: Button!
    
    fileprivate var weightManager: WeightManager!
    fileprivate var errorParser: NetworkErrorParser!
    fileprivate var router: BaseRouter!
    
    weak var delegate: EditInfoCompleteDeligate?
    
    enum State {
        case editing(WeightInfo)
        case creating
    }
    var state: State = .creating
    
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
        
        switch state {
        case .editing(let info):
            titleLabel.text = "Изменение информации"
            button.setTitle("Изменить", for: .normal)
            weightField.text = "\(info.amount)"
            dateTimeField.date = info.weighedAt
        case .creating:
            titleLabel.text = "Добавление информации"
            button.setTitle("Добавить", for: .normal)
        }
        
        validateForm()
    }

    @IBAction func processing(_ sender: Any) {
        guard let weightStr = weightField.text?.replacingOccurrences(of: ",", with: "."),
            let weight = Double(weightStr) else { return }
        LoaderView.instance.show()
        let weighedAt = dateTimeField.date
        switch state {
        case .creating:
            createInfo(weight: weight, weighedAt: weighedAt)
        case .editing(let info):
            editInfo(info, weight: weight, weighedAt: weighedAt)
        }
    }
    
    private func createInfo(weight: Double, weighedAt: Date) {
        weightManager.save(amount: weight, weighedAt: weighedAt) { (result) in
            LoaderView.instance.hide()
            switch result {
            case .success:
                self.delegate?.completed()
                DispatchQueue.main.async {
                    self.router.dismiss(aminated: true, completion: nil)
                }
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
    private func editInfo(_ info: WeightInfo, weight: Double, weighedAt: Date) {
        weightManager.update(id: info.id, amount: weight, weighedAt: weighedAt) { (result) in
            LoaderView.instance.hide()
            switch result {
            case .success:
                self.delegate?.completed()
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
