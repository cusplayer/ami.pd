//
//  ErrorParser.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> NetworkError {
        return .error(result)
    }
    func parse(response: URLResponse?, data: Data?, error: Error?) -> NetworkError? {
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
            !(200..<300 ~= statusCode),
            let data = data,
            let message = try? JSONDecoder().decode(ServerMessage.self, from: data) {
            return .serverFailed(code: statusCode, msg: message.message)
        }
        return nil
    }
}
