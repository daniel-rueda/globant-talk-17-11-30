//
//  GitHubServiceConcreteTests.swift
//  GlobantTechTalkTests
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import XCTest
@testable import GlobantTechTalk

class NetworkManagerMock: NetworkManager {
    var errorToReturn: Error?
    var data = "Test".data(using: .utf8)!
    func request(url: URL, onSuccess: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        if let error = errorToReturn {
            onFailure(error)
        } else {
            onSuccess(data)
        }
    }
}

class GitHubServiceConcreteTests: XCTestCase {

    var service = GitHubServiceConcrete()
    var manager = NetworkManagerMock()

    override func setUp() {
        super.setUp()
        service.manager = self.manager
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatValueIsReceivedWhenServiceReturnsValidData() {
        let expectation = self.expectation(description: "Service returned data")
        service.loadQuote(onSuccess: { (value) in
            XCTAssertEqual(value, "Test")
            expectation.fulfill()
        }, onFailure: { (error) in
            XCTFail("Error was received when data was expected")
        })
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatErrorIsReceivedWhenServiceFails() {
        let expectation = self.expectation(description: "Service returned error")
        manager.errorToReturn = NetworkError.forbidden
        service.loadQuote(onSuccess: { (value) in
            XCTFail("Value was received when error was expected")
        }, onFailure: { (error) in
            XCTAssertEqual(error, "Error: The operation couldn’t be completed. (GlobantTechTalk.NetworkError error 0.)")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 0.5, handler: nil)
    }

}
