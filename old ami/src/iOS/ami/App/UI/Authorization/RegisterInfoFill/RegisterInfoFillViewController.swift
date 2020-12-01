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
import NetworkCore
import DesignKit

protocol RegisterInfoFillViewControllerDelegate: class {
    func completed()
}

// MARK: - Builder

class RegisterInfoFillViewControllerBuilder {
    
    static func build(state: RegisterInfoFillViewController.State) -> RegisterInfoFillViewController {
        let controller = RegisterInfoFillViewController()
        controller.authManager = AuthManager()
        controller.userManager = UserManager()
        controller.errorParser = NetworkErrorParser()
        controller.state = state
        return controller
    }
    
}

class RegisterInfoFillViewController: UIViewController {
    
    enum State {
        case register(email: String, password: String), edition
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoPlaceholderView: InfoPlaceholderView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var button: Button!
    
    // MARK: - Properties
    
    var state: State!
    weak var delegate: RegisterInfoFillViewControllerDelegate?
    
    // MARK: Dependences
    
    var authManager: AuthManager!
    var userManager: UserManager!
    var router: IRegisterInfoFillRouter!
    var keyboardHelper: KeyboardHelper!
    var errorParser: NetworkErrorParser!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hideKeyboardWhenTapped()
        errorParser.delegate = self
        keyboardHelper = KeyboardHelper(view: view,
                                        scrollView: scrollView)
        keyboardHelper.startObserve()
        configure()
    }
    
    deinit {
        keyboardHelper.stopObserve()
    }
    
    // MARK: - Configure
    
    private func loadData() {
        userManager.get { (result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.fillFields(for: user)
                }
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
    private func fillFields(for userData: User) {
        infoPlaceholderView.nameField.text = userData.name
        infoPlaceholderView.surnameField.text = userData.surname
        infoPlaceholderView.birthdateField.date = userData.birthdate
        infoPlaceholderView.heightField.text = String(userData.height)
    }
    
    private func configure() {
        switch state {
        case .register:
            button.setTitle("Зарегистрироваться", for: .normal)
            infoPlaceholderView.weightField.isHidden = false
        case .edition:
            button.setTitle("Сохранить", for: .normal)
            loadData()
            infoPlaceholderView.weightField.isHidden = true
        default: fatalError()
        }
    }
    
    // MARK: - Actions

    @IBAction func processing(_ sender: Any) {
        guard let name = infoPlaceholderView.nameField.text,
            let surname = infoPlaceholderView.surnameField.text,
            let heightStr = infoPlaceholderView.heightField.text?.replacingOccurrences(of: ",", with: "."),
            let height = Double(heightStr) else {
                return
        }
        let birthdate = infoPlaceholderView.birthdateField.date
        switch state {
        case .register(let email, let password):
            guard let weightStr = infoPlaceholderView.weightField.text?.replacingOccurrences(of: ",", with: "."),
                let weight = Double(weightStr) else { return }
            LoaderView.instance.show()
            authManager.register(email: email,
                                 password: password,
                                 name: name,
                                 surname: surname,
                                 birthdate: birthdate,
                                 weight: weight,
                                 height: height,
                                 appleId: nil,
                                 vkId: nil) {
                                    LoaderView.instance.hide()
                                    self.proccessRegisterResponse($0)
            }
        case .edition:
            LoaderView.instance.show()
            userManager.update(email: nil,
                               password: nil,
                               name: name,
                               surname: surname,
                               birthdate: birthdate,
                               height: height,
                               appleId: nil,
                               vkId: nil) { (result) in
                                LoaderView.instance.hide()
                                self.proccessUpdateResponse(result)
            }
        default: fatalError()
        }
    }
    
    // MARK: - Private
    
    private func proccessRegisterResponse(_ response: NetworkResultWithModel<AuthData>) {
        switch response {
        case .success(let authData):
            showAlert(alertText: "Успешно!",
                      alertMessage: "Ваш ID в системе: \(authData.user.id)\nТокен доступа: \(authData.accessToken)") {
                self.router.toNext()
            }
        case .failure(let error):
            errorParser.parse(error)
        }
    }
    
    private func proccessUpdateResponse(_ response: NetworkResultWithModel<User>) {
        switch response {
        case .success:
            DispatchQueue.main.async {
                self.router.toNext()
                self.delegate?.completed()
            }
        case .failure(let error):
            errorParser.parse(error)
        }
    }

}

// MARK: - NetworkErrorParserDelegate

extension RegisterInfoFillViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message) {
            DispatchQueue.main.async {
                self.router.goBack()
            }
        }
    }
    
    func goToAuth() { }
    
}
