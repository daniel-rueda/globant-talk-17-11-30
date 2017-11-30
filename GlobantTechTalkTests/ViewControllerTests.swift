//
//  ViewControllerTests.swift
//  GlobantTechTalkTests
//
//  Created by Daniel Rueda on 11/29/17.
//  Copyright © 2017 Daniel Rueda Jimenez. All rights reserved.
//

import XCTest
@testable import GlobantTechTalk

class GitHubServiceMock: GitHubService {
    var successValue = "Success"
    var errorToReturn: String?

    var onQuoteLoaded: (() -> Void)?
    func loadQuote(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
        if let error = errorToReturn {
            onFailure(error)
        } else {
            onSuccess(successValue)
        }
        onQuoteLoaded?()
    }
}

class AlertPresenterMock: AlertPresenter {
    var showCount = 0
    var lastMessage = ""
    func show(message: String) {
        showCount += 1
        lastMessage = message
    }
}

class TableViewRowActionsProviderMock: TableViewRowActionsProvider {
    var deleteActionCount = 0
    func deleteAction(forRowAt indexPath: IndexPath, from tableView: UITableView, performAction: @escaping (Int) -> Void) -> UITableViewRowAction {
        deleteActionCount += 1
        performAction(indexPath.row)
        return UITableViewRowAction()
    }
}

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!
    var service = GitHubServiceMock()
    var presenter = AlertPresenterMock()
    var provider = TableViewRowActionsProviderMock()

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mx.drj.storyboard.controller")
        viewController = controller as? ViewController
        viewController.service = self.service
        viewController.presenter = self.presenter
        viewController.actionsProvider = self.provider
        _ = viewController.view
    }

    override func tearDown() {
        super.tearDown()
        service.onQuoteLoaded = nil
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
        viewController.values = ["One"]

        // When the provider is invoked the associated action is performed, thus removing the value from the array
        let actions = viewController.tableView(viewController.tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(provider.deleteActionCount, 1)
        XCTAssertEqual(actions?.count, 1)
        XCTAssertEqual(viewController.values.count, 0)
    }

    func testThatValueIsAddedWhenServiceReturnsSuccess() {
        let expectation = self.expectation(description: "Service was called")
        service.onQuoteLoaded = { expectation.fulfill() }

        service.errorToReturn = nil

        let sender = UIBarButtonItem()
        viewController.addTapped(sender)
        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertEqual(viewController.values.last, service.successValue)
    }

    func testThatErrorIsPresentedWhenServiceFails() {
        let expectation = self.expectation(description: "Service was called")
        service.onQuoteLoaded = { expectation.fulfill() }

        service.errorToReturn = "Error message"

        let sender = UIBarButtonItem()
        viewController.addTapped(sender)
        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertEqual(presenter.showCount, 1)
        XCTAssertEqual(presenter.lastMessage, "Error message")
    }

}
