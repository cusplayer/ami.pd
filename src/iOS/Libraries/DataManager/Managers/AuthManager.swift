//
//  AuthManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage
import CryptoSwift

public class AuthManager: IDataManager<AuthAPI, User> {
    
    public func register(email: String,
                         password: String,
                         name: String,
                         surname: String,
                         birthdate: Date,
                         weight: Double,
                         height: Double,
                         appleId: String?,
                         vkId: Int?,
                         completion: @escaping (NetworkResultWithModel<AuthData>) -> Void) {
        let api: AuthAPI = .register(email: email,
                                     password: password.md5(),
                                     name: name,
                                     surname: surname,
                                     birthdate: Int(birthdate.timeIntervalSince1970),
                                     weight: weight,
                                     height: height,
                                     appleId: appleId,
                                     vkId: vkId)
        provider.load(api) { (result: NetworkResultWithModel<AuthData>) in
            switch result {
            case .success(let response):
                self.storage.write(response.user)
                TokenManager.accessToken = response.accessToken
            default: break
            }
            completion(result)
        }
    }
    
    public func loginWithEmail(_ email: String, password: String,
                               completion: @escaping (NetworkResultWithModel<AuthData>) -> Void) {
        let api: AuthAPI = .login(email: email,
                                  password: password.md5(),
                                  appleId: nil,
                                  vkId: nil)
        provider.load(api) { (result: NetworkResultWithModel<AuthData>) in
            switch result {
            case .success(let response):
                self.storage.write(response.user)
                TokenManager.accessToken = response.accessToken
            default: break
            }
            completion(result)
        }
    }
    
    public func loginWithAppleId(_ appleId: String, password: String,
                                 completion: @escaping (NetworkResultWithModel<AuthData>) -> Void) {
        let api: AuthAPI = .login(email: nil, password: nil, appleId: appleId, vkId: nil)
        provider.load(api) { (result: NetworkResultWithModel<AuthData>) in
            switch result {
            case .success(let response):
                self.storage.write(response.user)
                TokenManager.accessToken = response.accessToken
            default: break
            }
            completion(result)
        }
    }
    
    public func loginWithVkId(_ vkId: Int, password: String,
                              completion: @escaping (NetworkResultWithModel<AuthData>) -> Void) {
        let api: AuthAPI = .login(email: nil, password: nil, appleId: nil, vkId: vkId)
        provider.load(api) { (result: NetworkResultWithModel<AuthData>) in
            switch result {
            case .success(let response):
                self.storage.write(response.user)
                TokenManager.accessToken = response.accessToken
            default: break
            }
            completion(result)
        }
    }
    
    public func restore(with email: String,
                        completion: @escaping (NetworkResultWithModel<ServerMessage>) -> Void) {
        let api: AuthAPI = .restore(email: email)
        provider.load(api) {
            completion($0)
        }
    }
    
}
