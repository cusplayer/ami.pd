//
//  RegisterViewController.swift
//  ami
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import UIUtils
import Validator
import DesignKit

// MARK: - Builder

class RegisterViewControllerBuilder {
    
    static func build() -> UINavigationController {
        let controller = RegisterViewController()
        controller.authValidator = AuthValidator()
        controller.router = RegisterRouter(controller: controller)
        return UINavigationController(rootViewController: controller)
    }
    
}

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var confirmPasswordField: TextField!
    @IBOutlet weak var continueButton: Button!
    
    // MARK: - Properties
    
    private weak var selectedField: TextField?
    
    // MARK: Dependences
    
    var router: RegisterRouter!
    var authValidator: AuthValidator!
    var keyboardHelper: KeyboardHelper!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        keyboardHelper = KeyboardHelper(view: view,
                                        scrollView: scrollView)
        keyboardHelper.startObserve()
        view.hideKeyboardWhenTapped()
        validateForm()
    }
    
    private func configureTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        keyboardHelper.stopObserve()
    }
    
    // MARK: - Actions

    @IBAction func toLogin(_ sender: Any) {
        router.toLogin()
    }
    
    @IBAction func continueRegister(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        router.toInfoPlaceholder(email: email, password: password)
    }
    
    // MARK: - Private
    
    private func validateForm() {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        let isValidConfirmPassword = authValidator.validateConfirmPassword(password: passwordField,
                                                             confirmPassword: confirmPasswordField)
        continueButton.setEnabled(isValidEmail && isValidPassword && isValidConfirmPassword)
    }
    
}

// MARK: - TextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
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
            guard emailField.isValid != nil, isStrictly else { break }
            emailField.isValid = authValidator.validateEmail(emailField)
        case passwordField:
            guard passwordField.isValid != nil, isStrictly else { break }
            passwordField.isValid = authValidator.validatePassword(passwordField)
        case confirmPasswordField:
            guard confirmPasswordField.isValid != nil, isStrictly else { break }
            confirmPasswordField.isValid = authValidator.validateConfirmPassword(password: passwordField,
                                                                                 confirmPassword: confirmPasswordField)
        default: fatalError()
        }
    }
    
}
