//
//  TestUtils.swift
//  DataManager
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import DataManager

class TestUtils {
    
    static let correctEmail = "test@apihp.ru"
    static let correctPassword = "amihp12345"
    
    static func loginForTest() {
        let auth = AuthManager()
        auth.loginWithEmail(TestUtils.correctEmail,
                            password: TestUtils.correctPassword) {
            switch $0 {
            case .failure(let error):
                switch error {
                case .serverFailed(let code, _):
                    if 400..<500 ~= code {
                        registerForTest()
                    }
                default: break
                }
            default: break
            }
        }
    }
    
    static func registerForTest() {
        let auth = AuthManager()
        auth.register(email: correctEmail,
                      password: correctPassword,
                      name: "Артем",
                      surname: "Куфаев",
                      birthdate: Date(timeIntervalSince1970: 916126137),
                      weight: 81.7,
                      height: 181.5,
                      appleId: "",
                      vkId: 305991725) { _ in }
    }
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    static func randomEmail() -> String {
        return randomString(length: 8) + "@gmail.com"
    }
    
}
