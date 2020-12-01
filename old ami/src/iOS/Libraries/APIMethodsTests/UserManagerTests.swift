//
//  UserManagerTests.swift
//  DataManager
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import DataManager

class UserManagerTests: XCTestCase {
    
    lazy var manager: UserManager = UserManager()
    
    override func setUp() {
        super.setUp()
        TestUtils.loginForTest()
    }
    
    func testGetting() {
        let exp = self.expectation(description: "Loading from server")
        var count = 0
        manager.get { (result) in
            switch result {
            case .success(let data):
                count += 1
                dump(data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
            if count == 2 {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdating() {
        let exp = self.expectation(description: "Loading from server")
        manager.update(email: "new" + TestUtils.correctEmail,
                       password: TestUtils.correctPassword + "1234",
                       name: "Максим",
                       surname: "Хоцевич",
                       birthdate: Date(timeIntervalSince1970: 959446290),
                       height: 160,
                       appleId: nil,
                       vkId: nil) { (result) in
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
