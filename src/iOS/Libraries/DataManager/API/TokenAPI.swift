//
//  TokenAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum TokenAPI {
    case refresh(String)
}

extension TokenAPI: INetworkAPI {
    
    public var headers: HTTPHeaders? { return nil }
    
    public var path: String {
        let path = "token/"
        switch self {
        case .refresh:
            return path + "refresh/"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .refresh:
            return .post
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .refresh(let accessToken):
            return .requestParameters(bodyParameters: ["accessToken": accessToken],
                                      urlParameters: nil)
        }
    }
    
}
