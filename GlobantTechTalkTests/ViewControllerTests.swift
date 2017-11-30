//
//  ViewControllerTests.swift
//  GlobantTechTalkTests
//
//  Created by Daniel Rueda on 11/29/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import XCTest
@testable import GlobantTechTalk

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mx.drj.storyboard.controller")
        viewController = controller as? ViewController
        _ = viewController.view
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatTableReturnsNumberOfRows() {
        let expected = viewController.values.count
        let result = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(expected, result)
    }

    func testThatTableReturnsCellWithData() {
        viewController.values = ["One"]
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual("One", cell.textLabel?.text)
    }

    func testThatTableReturnsActions() {
        let actions = viewController.tableView(viewController.tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))!
        XCTAssertEqual(actions.count, 1)
    }

}
