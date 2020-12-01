//
//  LoginViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DesignKit
import DataManager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var continueButton: Button!
    
    var router: LoginRouter!
    var authManager: AuthManager!
    var authValidator: AuthValidator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = LoginRouter(controller: self)
        authValidator = AuthValidator()
        authManager = AuthManager()
        validateForm()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.hideKeyboardWhenTapped()
    }
    
    private func validateForm() {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        
        continueButton.setEnabled(isValidEmail && isValidPassword)
    }

    @IBAction func login(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        authManager.loginWithEmail(email, password: password) { (result) in
            switch result {
            case .success(let authData):
                self.showAlert(alertText: "Успешно!", alertMessage: "Ваш ID в системе: \(authData.user.id)\nТокен доступа: \(authData.accessToken)") {
                    self.router.toMain()
                }
            case .failure(let error):
                switch error {
                case .serverFailed(let code, let msg):
                    self.showAlert(alertText: "Ошибка сервера \(code)", alertMessage: msg) { }
                default:
                    self.showAlert(alertText: "Сетевая ошибка", alertMessage: error.localizedDescription) { }
                }
            }
        }
    }
    
    @IBAction func toRegister(_ sender: Any) {
        router.toRegister()
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? TextField else { return }
        
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        
        switch textField {
        case emailField:
            guard emailField.isValid != nil else { return }
            emailField.isValid = isValidEmail
        case passwordField:
            guard passwordField.isValid != nil else { return }
            passwordField.isValid = isValidPassword
        default: fatalError()
        }
        
        continueButton.setEnabled(isValidEmail && isValidPassword)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        
        switch textField {
        case emailField:
            emailField.isValid = isValidEmail
        case passwordField:
            passwordField.isValid = isValidPassword
        default: fatalError()
        }
        
        continueButton.setEnabled(isValidEmail && isValidPassword)
    }
    
}
