//
//  WaterHistoryTableViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager

// MARK: - Builder

class WaterHistoryViewControllerBuilder {
    
    static func build() -> WaterHistoryViewController {
        let controller = WaterHistoryViewController()
        controller.waterManager = WaterManager()
        controller.errorParser = NetworkErrorParser()
        controller.errorParser.delegate = controller
        return controller
    }
    
}

class WaterHistoryViewController: UITableViewController {
    
    // MARK: - Dependences
    
    fileprivate var waterManager: WaterManager!
    fileprivate var errorParser: NetworkErrorParser!
    
    // MARK: - Properties
    
    private var waterHistory: [WaterInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Private
    
    private func loadData() {
        waterManager.get { (result) in
            switch result {
            case .success(let history):
                self.waterHistory = history
                    .sorted { $0.drinkedAt > $1.drinkedAt }
            case .failure(let error):
                self.errorParser.parse(error)
            }
        }
    }
    
}

// MARK: - TableViewDataSource

extension WaterHistoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waterHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let waterInfo = waterHistory[indexPath.row]
        
        let date = DateHelper.prettyDate(from: waterInfo.drinkedAt)
        cell.textLabel?.text = "\(waterInfo.amount) мл \(date)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            waterManager.delete(id: waterHistory[indexPath.row].id) { (result) in
                switch result {
                case .failure(let error):
                    self.errorParser.parse(error)
                default: break
                }
            }
            waterHistory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: - NetworkErrorParserDelegate

extension WaterHistoryViewController: NetworkErrorParserDelegate {
    
    func showMessage(_ message: String) {
        showAlert(alertText: "Ошибка", alertMessage: message)
    }
    
    func goToAuth() {
        toMain()
    }
    
}
