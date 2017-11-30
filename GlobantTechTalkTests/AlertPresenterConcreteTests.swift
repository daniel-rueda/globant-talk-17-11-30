//
//  AlertPresenterConcreteTests.swift
//  GlobantTechTalkTests
//
//  Created by Daniel Rueda on 11/30/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import XCTest
@testable import GlobantTechTalk

class ViewControllerMock: UIViewController {
    var presentCount = 0
    var lastViewControllerPresented: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCount += 1
        lastViewControllerPresented = viewControllerToPresent
    }
}

class AlertPresenterConcreteTests: XCTestCase {

    var presenter = AlertPresenterConcrete()
    var controller = ViewControllerMock()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatAlertControllerIsPresented() {
        presenter.show(message: "Message", from: controller)

        XCTAssertEqual(controller.presentCount, 1)
        XCTAssertTrue(controller.lastViewControllerPresented is UIAlertController)
    }

}
