//
//  UserManager.swift
//  DataManager
//
//  Created by Artem Kufaev on 31.05.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import NetworkCore
import Storage
import CryptoSwift

public class UserManager: IDataManager<UserAPI, User> {
    
    public func get(completion: @escaping (NetworkResultWithModel<User>) -> Void) {
        let api: UserAPI = .get
        storage.readAll { (users) in
            if let user = users.first {
                completion(.success(user))
            }
            self.storage.delete(users)
        }
        provider.load(api) { (result: NetworkResultWithModel<User>) in
            switch result {
            case .success(let user):
                self.storage.write(user)
            default: break
            }
            completion(result)
        }
    }
    
    public func update(email: String?,
                       password: String?,
                       name: String?,
                       surname: String?,
                       birthdate: Date?,
                       height: Double?,
                       appleId: String?,
                       vkId: Int?,
                       completion: @escaping (NetworkResultWithModel<User>) -> Void) {
        var birthdateInt: Int?
        if let bdate = birthdate?.timeIntervalSince1970 {
            birthdateInt = Int(bdate)
        }
        let api: UserAPI = .update(email: email,
                                   password: password?.md5(),
                                   name: name,
                                   surname: surname,
                                   birthdate: birthdateInt,
                                   height: height,
                                   appleId: appleId,
                                   vkId: vkId)
        provider.load(api) { (result: NetworkResultWithModel<User>) in
            switch result {
            case .success(let user):
                self.storage.write(user)
            default: break
            }
            completion(result)
        }
    }
    
}
