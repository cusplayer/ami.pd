//
//  NetworkError.swift
//  NetworkCore
//
//  Created by Artem Kufaev on 10.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case parametersNil
    case encodingFailed
    case missingURL
    case decodingFailed(Error, Data)
    case serverFailed(code: Int, msg: String?)
    case noData
    case error(Error)
    
    public var localizedDescription: String {
        switch self {
        case .parametersNil: return "Parameters were nil"
        case .encodingFailed: return "Parameter encoding failed"
        case .missingURL: return "URL is nil"
        case .decodingFailed(let error, let data):
            let msg = "Decoding data failed, error: \(error)"
            if let data = String(data: data, encoding: .utf8) {
                return msg + "\n" + data
            } else {
                return msg
            }
        case .serverFailed(let code, let msg):
            var rtn = "The server returned an error with the code \(code)"
            if let msg = msg {
                rtn += " and message: \(msg)"
            }
            return rtn
        case .noData:
            return "No data"
        case .error(let error):
            return error.localizedDescription
        }
    }
}
