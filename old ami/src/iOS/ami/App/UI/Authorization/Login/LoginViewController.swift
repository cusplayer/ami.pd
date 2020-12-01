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
import UIUtils
import NetworkCore

// MARK: - Builder

class LoginViewControllerBuilder {
    
    static func build() -> LoginViewController {
        let controller = LoginViewController()
        controller.router = LoginRouter(controller: controller)
        controller.authManager = AuthManager()
        controller.authValidator = AuthValidator()
        controller.errorParser = NetworkErrorParser()
        return controller
    }
    
}

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var continueButton: Button!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    // MARK: Dependences
    
    fileprivate var router: LoginRouter!
    fileprivate var authManager: AuthManager!
    fileprivate var authValidator: AuthValidator!
    fileprivate var keyboardHelper: KeyboardHelper!
    fileprivate var errorParser: NetworkErrorParser!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        validateForm()
        
        keyboardHelper = KeyboardHelper(view: view, scrollView: scrollView)
        keyboardHelper.startObserve()
        
        errorParser.delegate = self
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.hideKeyboardWhenTapped()
    }
    
    deinit {
        keyboardHelper.stopObserve()
    }

    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        LoaderView.instance.show()
        authManager.loginWithEmail(email, password: password) { (result) in
            LoaderView.instance.hide()
            self.processResponse(result)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toRegister(_ sender: Any) {
        router.toRegister()
    }
    
    // MARK: - Private
    
    private func processResponse(_ result: NetworkResultWithModel<AuthData>) {
        switch result {
        case .success(let authData):
            self.showAlert(alertText: "Успешно!", alertMessage: "Ваш ID в системе: \(authData.user.id)\nТокен доступа: \(authData.accessToken)") {
                self.toMain()
            }
        case .failure(let error):
            errorParser.parse(error)
        }
    }
    
    private func validateForm() {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        
        continueButton.setEnabled(isValidEmail && isValidPassword)
    }

}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateTextField(textField, isStrictly: true)
        validateForm()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextField(textField, isStrictly: false)
        validateForm()
    }
    
    private func validateTextField(_ textField: UITextField, isStrictly: Bool) {
        switch textField {
        case emailField:
            emailField.isValid = authValidator.validateEmail(emailField)
        case passwordField:
            passwordField.isValid = authValidator.validatePassword(passwordField)
        default: fatalError()
        }
    }
    
}

// MARK: - NetworkErrorParserDelegate

extension LoginViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() { }
    
}
