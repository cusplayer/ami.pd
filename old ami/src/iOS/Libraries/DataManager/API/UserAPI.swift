//
//  UserAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum UserAPI {
    case get
    case update(
        email: String?,
        password: String?,
        name: String?,
        surname: String?,
        birthdate: Int?,
        height: Double?,
        appleId: String?,
        vkId: Int?
    )
}

extension UserAPI: INetworkAPI {
    
    public var path: String { return "user/" }
    
    public var headers: HTTPHeaders? {
        return ["Authorization": "Bearer " + accessToken]
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .get: return .get
        case .update: return .put
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .get:
            return .request
        case .update(let email,
                         let password,
                         let name,
                         let surname,
                         let birthdate,
                         let height,
                         let appleId,
                         let vkId):
            var parameters: Parameters = [:]
            if let email = email {
                parameters["email"] = email
            }
            if let password = password {
                parameters["password"] = password
            }
            if let name = name {
                parameters["name"] = name
            }
            if let surname = surname {
                parameters["surname"] = surname
            }
            if let birthdate = birthdate {
                parameters["birthdate"] = birthdate
            }
            if let height = height {
                parameters["height"] = height
            }
            if let appleId = appleId {
                parameters["appleId"] = appleId
            }
            if let vkId = vkId {
                parameters["vkId"] = vkId
            }
            return .requestParameters(bodyParameters: parameters,
                                      urlParameters: nil)
        }
    }
    
}
