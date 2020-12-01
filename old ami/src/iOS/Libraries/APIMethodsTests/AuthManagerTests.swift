//
//  AuthManagerTests.swift
//  APIMethodsTests
//
//  Created by Artem Kufaev on 28.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import DataManager

class AuthManagerTests: XCTestCase {
    
    lazy var auth: AuthManager = AuthManager()
    
    override func setUp() {
        super.setUp()
        TestUtils.loginForTest()
    }
    
    func testRegister() {
        let exp = self.expectation(description: "Loading from server")
        let randomer = TestUtils.randomString
        auth.register(email: TestUtils.randomEmail(),
                      password: randomer(15),
                      name: randomer(5),
                      surname: randomer(8),
                      birthdate: Date(timeIntervalSince1970: TimeInterval(Int.random(in: 10...10))),
                      weight: Double.random(in: 10...300),
                      height: Double.random(in: 30...240),
                      appleId: randomer(10),
                      vkId: Int.random(in: 1...10000)) { (result) in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLogin() {
        let exp = self.expectation(description: "Loading from server")
        auth.loginWithEmail(TestUtils.correctEmail,
                            password: TestUtils.correctPassword) { (result) in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginNotCorrectPassword() {
        let exp = self.expectation(description: "Loading from server")
        auth.loginWithEmail(TestUtils.correctEmail,
                            password: TestUtils.randomString(length: 10)) { (result) in
            switch result {
            case .success(let data):
            dump(data)
                XCTFail("Сервер пропустил некорректный пароль")
            case .failure(let error):
                print(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginBadEmail() {
        let exp = self.expectation(description: "Loading from server")
        auth.loginWithEmail(TestUtils.randomString(length: 10),
                            password: TestUtils.randomString(length: 10)) { (result) in
            switch result {
            case .success(let data):
            dump(data)
                XCTFail("Сервер пропустил некорректную почту")
            case .failure(let error):
                print(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginNotCorrectEmail() {
        let exp = self.expectation(description: "Loading from server")
        auth.loginWithEmail(TestUtils.randomEmail(),
                            password: TestUtils.randomString(length: 10)) { (result) in
            switch result {
            case .success(let data):
            dump(data)
                XCTFail("Сервер пропустил некорректную почту")
            case .failure(let error):
                print(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testRestore() {
        let exp = self.expectation(description: "Loading from server")
        auth.restore(with: TestUtils.correctEmail) { (result) in
            switch result {
            case .success(let data):
                dump(data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

}
