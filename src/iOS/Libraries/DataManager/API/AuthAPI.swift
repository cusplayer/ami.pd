//
//  AuthAPI.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore

public enum AuthAPI {
    case register(
        email: String,
        password: String,
        name: String,
        surname: String,
        birthdate: Int,
        weight: Double,
        height: Double,
        appleId: String?,
        vkId: Int?
    )
    case login(
        email: String?,
        password: String?,
        appleId: String?,
        vkId: Int?
    )
    case restore(
        email: String
    )
}

extension AuthAPI: INetworkAPI {
    
    public var httpMethod: HTTPMethod { return .post }
    public var headers: HTTPHeaders? { return nil }
    
    public var path: String {
        switch self {
        case .register: return "auth/register/"
        case .login: return "auth/login/"
        case .restore: return "auth/restore/"
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .login(let email, let password, let appleId, let vkId):
            var parameters: Parameters = [:]
            if let email = email,
                let password = password {
                parameters["email"] = email
                parameters["password"] = password
            }
            if let appleId = appleId {
                parameters["appleId"] = appleId
            }
            if let vkId = vkId {
                parameters["vkId"] = vkId
            }
            return .requestParameters(bodyParameters: parameters,
                                      urlParameters: nil)
            
        case .register(let email,
                       let password,
                       let name,
                       let surname,
                       let birthdate,
                       let weight,
                       let height,
                       let appleId,
                       let vkId):
            var parameters: Parameters = [
                "email": email,
                "password": password,
                "name": name,
                "surname": surname,
                "birthdate": birthdate,
                "weight": weight,
                "height": height
            ]
            if let appleId = appleId {
                parameters["appleId"] = appleId
            }
            if let vkId = vkId {
                parameters["vkId"] = vkId
            }
            return .requestParameters(bodyParameters: parameters,
                                      urlParameters: nil)
            
        case .restore(let email):
            return .requestParameters(bodyParameters: ["email": email],
                                      urlParameters: nil)
        }
    }
    
}
