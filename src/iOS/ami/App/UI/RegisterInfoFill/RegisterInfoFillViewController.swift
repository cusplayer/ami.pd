//
//  RegisterInfoFillViewController.swift
//  ami
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import UIUtils
import DataManager

class RegisterInfoFillViewController: UIViewController {
    
    @IBOutlet weak var infoPlaceholderView: InfoPlaceholderView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var registerData: (email: String, password: String)!
    
    var authManager: AuthManager!
    var router: RegisterInfoFillRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hideKeyboardWhenTapped()
        authManager = AuthManager()
        router = RegisterInfoFillRouter(controller: self)
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

    @IBAction func startRegisterProccess(_ sender: Any) {
        guard let email = registerData?.email,
            let password = registerData?.password,
            let name = infoPlaceholderView.nameField.text,
            let surname = infoPlaceholderView.surnameField.text,
            let heightStr = infoPlaceholderView.heightField.text,
            let height = Double(heightStr),
            let weightStr = infoPlaceholderView.weightField.text,
            let weight = Double(weightStr) else {
                return
        }
        let birthdate = infoPlaceholderView.birthdateField.date
        authManager.register(email: email,
                             password: password,
                             name: name,
                             surname: surname,
                             birthdate: birthdate,
                             weight: weight,
                             height: height,
                             appleId: nil,
                             vkId: nil) { (result) in
            switch result {
            case .success(let authData):
                self.showAlert(alertText: "Успешно!", alertMessage: "Ваш ID в системе: \(authData.user.id)\nТокен доступа: \(authData.accessToken)") {
                    self.router.toMain()
                }
            case .failure(let error):
                switch error {
                case .serverFailed(let code, let msg):
                    self.showAlert(alertText: "Ошибка сервера \(code)", alertMessage: msg) {
                        self.router.goBack()
                    }
                default:
                    self.showAlert(alertText: "Сетевая ошибка", alertMessage: error.localizedDescription) { }
                }
            }
        }
    }

}
