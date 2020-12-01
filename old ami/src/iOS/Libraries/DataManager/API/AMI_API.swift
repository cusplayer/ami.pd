//
//  AMI_API.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

extension INetworkAPI {
    public var host: String {
        guard let host = Bundle(for: TokenManager.self).object(forInfoDictionaryKey: "API Base URL") as? String
            else { fatalError("Установите конфигурацию!") }
        return host
    }
    public var schema: NetworkSchema {
        return .https
    }
    internal var accessToken: String {
        return TokenManager.accessToken ?? ""
    }
}
