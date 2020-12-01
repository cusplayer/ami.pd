//
//  ProfileViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager
import Storage

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Dependenses
    
    private var router: ProfileRouter!
    private var userManager: UserManager!
    private var weightManager: WeightManager!
    private var errorParser: NetworkErrorParser!
    
    // MARK: - Properties
    
    private var user: User! {
        didSet {
            DispatchQueue.main.async {
                self.configureFields()
            }
        }
    }
    private var weight: WeightInfo! {
        didSet {
            DispatchQueue.main.async {
                if let weight = self.weight {
                        let weight = weight.amount.rounded(toPlaces: 2)
                        self.weightLabel.text = "Вес: \(weight) кг"
                } else {
                    self.weightLabel.text = "Вес: NaN"
                }
            }
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        clearData()
        router = ProfileRouter(controller: self)
        userManager = UserManager()
        weightManager = WeightManager()
        errorParser = NetworkErrorParser()
        errorParser.delegate = self
        configureLogoutBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Private
    
    private func clearData() {
        fullNameLabel.text = "******* *******"
        birthdateLabel.text = "День рождения: **.**.****"
        heightLabel.text = "Рост: *** см"
        weightLabel.text = "Вес: **.* кг"
        emailLabel.text = "Почта: ********@*****.***"
    }
    
    private func loadData() {
        userManager.get { (result) in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
        weightManager.get { (result) in
            switch result {
            case .success(let history):
                self.weight = history
                    .sorted { $0.weighedAt > $1.weighedAt }
                    .first
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
    private func configureFields() {
        fullNameLabel.text = user.name + " " + user.surname
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: user.birthdate)
        birthdateLabel.text = "Дата рождения: \(date)"
        heightLabel.text = "Рост: \(user.height) см"
        emailLabel.text = "Почта: \(user.email)"
    }
    
    private func configureLogoutBtn() {
        let rightNavBtn = UIBarButtonItem(image: R.image.logout(),
                                          style: .plain,
                                          target: self,
                                          action: #selector(logout))
        rightNavBtn.tintColor = R.color.ba2()
        navigationItem.setRightBarButton(rightNavBtn, animated: true)
    }
    
    @objc
    private func logout() {
        showQuestion(title: "Вы уверены?", message: nil, completion: { (isLogout) in
            guard isLogout else { return }
            TokenManager.accessToken = nil
            self.toAuth()
        })
    }

    @IBAction func editData(_ sender: Any) {
        router.toEdit()
    }
    
}

extension ProfileViewController: RegisterInfoFillViewControllerDelegate {
    
    func completed() {
        loadData()
    }
    
}

extension ProfileViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}
