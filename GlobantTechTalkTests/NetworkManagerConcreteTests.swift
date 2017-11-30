//
//  NetworkManagerConcreteTests.swift
//  GlobantTechTalkTests
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import XCTest
@testable import GlobantTechTalk

class URLSessionDataTaskMock: URLSessionDataTask {
    override func resume() {
        // do nothing
    }
}

class URLSessionMock: URLSessionProtocol {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToReturn: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(dataToReturn, responseToReturn, errorToReturn)
        return URLSessionDataTaskMock()
    }
}

enum TestError: Error {
    case error
}

class NetworkManagerConcreteTests: XCTestCase {

    var manager = NetworkManagerConcrete()
    var session = URLSessionMock()
    let url = URL(string: "http://localhost")!

    override func setUp() {
        super.setUp()
        manager.session = self.session
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatOnSuccessIsCalledForValidData() {
        let expectedData = "".data(using: .utf8)!
        session.dataToReturn = expectedData

        let expectation = self.expectation(description: "onSuccess was called")
        manager.request(url: url, onSuccess: { (data) in
            XCTAssertEqual(data, expectedData)
            expectation.fulfill()
        }, onFailure: { (error) in
            XCTFail("Error was received \(error)")
        })

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatNetworkErrorIsGeneratedWhenServiceReturns403() {
        let response = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)
        session.responseToReturn = response

        let expectation = self.expectation(description: "onFailure was called")
        manager.request(url: url, onSuccess: { (data) in
            XCTFail("Data was received, error was expected")
        }, onFailure: { (error) in
            if let networkError = error as? NetworkError {
                XCTAssertTrue(networkError == .forbidden)
            } else {
                XCTFail("Unexpected error")
            }
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatErrorIsReceivedWhenServiceFails() {
        session.errorToReturn = TestError.error

        let expectation = self.expectation(description: "onFailure was called")
        manager.request(url: url, onSuccess: { (data) in
            XCTFail("Data was received, error was expected")
        }, onFailure: { (error) in
            XCTAssertTrue(error is TestError)
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.5, handler: nil)
    }

}
