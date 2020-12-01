//
//  WaterHistoryTableViewController.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import DataManager

class WaterHistoryViewController: UITableViewController {
    
    private var waterManager: WaterManager!
    
    private var waterHistory: [WaterInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        waterManager = WaterManager()
        
        loadData()
    }
    
    private func loadData() {
        waterManager.get { (result) in
            switch result {
            case .success(let history):
                self.waterHistory = history.sorted { $0.drinkedAt > $1.drinkedAt }
            case .failure(let error):
                self.showAlert(alertText: "Ошибка", alertMessage: error.localizedDescription)
            }
        }
    }
    
}

extension WaterHistoryViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return waterHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let waterInfo = waterHistory[indexPath.row]
        
        let date = DateHelper.prettyDate(from: waterInfo.drinkedAt)
        cell.textLabel?.text = "\(waterInfo.amount)мл \(date)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            waterManager.delete(id: waterHistory[indexPath.row].id) { (result) in
                switch result {
                case .failure(let error):
                    self.showAlert(alertText: "Ошибка", alertMessage: error.localizedDescription)
                default: break
                }
            }
            waterHistory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
