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

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var confirmPasswordField: TextField!
    
    @IBOutlet weak var continueButton: Button!
    
    var router: RegisterRouter!
    var authValidator: AuthValidator!
    
    private weak var selectedField: TextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        router = RegisterRouter(controller: self)
        authValidator = AuthValidator()
        view.hideKeyboardWhenTapped()
        validateForm()
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardHeight = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.contentOffset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func toLogin(_ sender: Any) {
        router.toLogin()
    }
    
    @IBAction func continueRegister(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        router.toInfoPlaceholder(email: email, password: password)
    }
    
    private func validateForm() {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        let isValidConfirmPassword = authValidator.validateConfirmPassword(password: passwordField,
                                                             confirmPassword: confirmPasswordField)
        
        continueButton.setEnabled(isValidEmail && isValidPassword && isValidConfirmPassword)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textField = textField as? TextField else { return }
        
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        let isValidConfirmPassword = authValidator.validateConfirmPassword(password: passwordField,
                                                             confirmPassword: confirmPasswordField)
        switch textField {
        case emailField:
            guard emailField.isValid != nil else { return }
            emailField.isValid = isValidEmail
        case passwordField:
            guard passwordField.isValid != nil else { return }
            passwordField.isValid = isValidPassword
        case confirmPasswordField:
            guard confirmPasswordField.isValid != nil else { return }
            confirmPasswordField.isValid = isValidConfirmPassword
        default: fatalError()
        }
        
        continueButton.setEnabled(isValidEmail && isValidPassword && isValidConfirmPassword)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isValidEmail = authValidator.validateEmail(emailField)
        let isValidPassword = authValidator.validatePassword(passwordField)
        let isValidConfirmPassword = authValidator.validateConfirmPassword(password: passwordField,
                                                             confirmPassword: confirmPasswordField)
        switch textField {
        case emailField:
            emailField.isValid = isValidEmail
        case passwordField:
            passwordField.isValid = isValidPassword
        case confirmPasswordField:
            confirmPasswordField.isValid = isValidConfirmPassword
        default: fatalError()
        }
        
        continueButton.setEnabled(isValidEmail && isValidPassword && isValidConfirmPassword)
    }
    
}
