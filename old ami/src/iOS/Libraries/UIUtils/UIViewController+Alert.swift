//
//  UIViewController+Alert.swift
//  UIUtils
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func showAlert(alertText: String, alertMessage: String?, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showQuestion(title: String, message: String?, completion: @escaping (Bool) -> Void = {_ in}) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
                completion(true)
            })
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
                completion(false)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
