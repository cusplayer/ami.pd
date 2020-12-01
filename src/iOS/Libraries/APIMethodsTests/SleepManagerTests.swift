//
//  SleepManagerTests.swift
//  DataManager
//
//  Created by Artem Kufaev on 29.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import XCTest
@testable import DataManager

class SleepManagerTests: XCTestCase {
    
    lazy var manager: SleepManager = SleepManager()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }
    
    func testCreating() {
        let exp = self.expectation(description: "Loading from server")
        manager.save(endAt: Date(timeIntervalSinceNow: -36000),
                     riseAt: Date()) { (result) in
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
            }
            if count == 2 {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdating() {
        let exp = self.expectation(description: "Loading from server")
        manager.save(endAt: Date(timeIntervalSinceNow: -36000),
                     riseAt: Date()) { (result) in
            switch result {
            case .success(let data):
                self.manager.update(id: data.id,
                                    endAt: Date(timeIntervalSinceNow: -41539),
                                    riseAt: Date(timeIntervalSinceNow: -10213)) { (result) in
                    switch result {
                    case .success(let data):
                        dump(data)
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                    exp.fulfill()
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testDeleting() {
        let exp = self.expectation(description: "Loading from server")
        manager.save(endAt: Date(timeIntervalSinceNow: -36000),
                     riseAt: Date()) { (result) in
            switch result {
            case .success(let data):
                self.manager.delete(id: data.id) { (result) in
                    switch result {
                    case .success:
                        dump("OK")
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
                exp.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

}
