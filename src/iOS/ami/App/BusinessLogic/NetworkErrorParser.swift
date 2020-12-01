//
//  NetworkErrorParser.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit
import NetworkCore
import DataManager

protocol NetworkErrorParserDelegate: class {
    func showMessage(_ message: String)
    func goToAuth()
}

class NetworkErrorParser {
    
    weak var delegate: NetworkErrorParserDelegate?
    
    func parse(_ error: NetworkError) {
        switch error {
        case .encodingFailed, .parametersNil, .missingURL, .noData:
            fatalError(error.localizedDescription)
        case .error, .decodingFailed:
            print(error.localizedDescription)
        case .serverFailed(let code, let msg):
            print(error.localizedDescription)
            switch code {
            case 400:
                if let msg = msg {
                    delegate?.showMessage(msg)
                } else {
                    delegate?.showMessage(error.localizedDescription)
                }
            case 401:
                TokenManager.accessToken = nil
                delegate?.goToAuth()
            case 500:
                delegate?.showMessage("Повторите попытку позже")
            default:
                delegate?.showMessage(error.localizedDescription)
            }
        }
    }
    
}
