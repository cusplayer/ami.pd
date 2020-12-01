//
//  WeightHistoryViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager

// MARK: - Builder

class WeightHistoryViewControllerBuilder {
    
    static func build() -> WeightHistoryViewController {
        let controller = WeightHistoryViewController()
        controller.weightManager = WeightManager()
        controller.errorParser = NetworkErrorParser()
        controller.errorParser.delegate = controller
        controller.router = WeightHistoryRouter(controller: controller)
        return controller
    }
    
}

private let reuseIdentifier = "reuseIdentifier"

class WeightHistoryViewController: UITableViewController {
    
    // MARK: - Dependences
    
    fileprivate var weightManager: WeightManager!
    fileprivate var errorParser: NetworkErrorParser!
    fileprivate var router: WeightHistoryRouter!
    
    // MARK: - Properties
    
    private(set) var weightHistory: [WeightInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        configureAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configure
    
    private func configureAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addWeightInfo))
    }
    
    // MARK: - Private
    
    @objc
    private func addWeightInfo() {
        router.toEditor(with: .creating)
    }
    
    private func loadData() {
        weightManager.get { (result) in
            switch result {
            case .success(let history):
                self.weightHistory = history
                    .sorted { $0.weighedAt > $1.weighedAt }
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
}

extension WeightHistoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = weightHistory[indexPath.row]
        router.toEditor(with: .editing(info))
    }
    
}

// MARK: - Table Data Source

extension WeightHistoryViewController {

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return weightHistory.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let weightInfo = weightHistory[indexPath.row]
        
        let date = DateHelper.prettyDate(from: weightInfo.weighedAt)
        cell.textLabel?.text = "\(weightInfo.amount) кг \(date)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weightManager.delete(id: weightHistory[indexPath.row].id) { (result) in
                switch result {
                case .failure(let error):
                    self.errorParser.parse(error)
                default: break
                }
            }
            weightHistory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension WeightHistoryViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}

extension WeightHistoryViewController: EditInfoCompleteDeligate {
    
    func completed() {
        loadData()
    }
    
}
