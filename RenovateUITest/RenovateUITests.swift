//
//  RenovateUITests.swift
//  RenovateUITests
//
//  Created by T  on 2021-04-13.
//

import XCTest

class RenovateUITests: XCTestCase {
    // That works best as an implicitly unwrapped optional because
    // it will be created immediately and never be destroyed before an assertion is made.
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppHas4Tabs() throws {
        // UI tests must launch the application that they test.

        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


    func testOpenTabAddsActions()  throws {
        app.buttons["Open"].tap()
        //attempt to locate a table (List, in SwiftUI) on the screen
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["add"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
        }
    }


    func testAddingRenovationInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a renovation.")

        app.buttons["Add New Action"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an action.")
    }

    func testEditingRenovationUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a renovation.")

        app.buttons["NEW RENOVATION"].tap()
        app.textFields["Renovation name"].tap()

        /*
         Now, XCTest actually provides a typeText() method that lets us insert free text strings, but honestly it’s pretty buggy –
         often it will only type a handful of the characters you want.
         The only guaranteed way to accurately type is to press individual keys manually,
         including switching between alphabetic and numeric keyboards by pressing what’s called the “more” button on the keyboard
         */
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()


        app.buttons["Open Renovations"].tap()

        XCTAssertTrue(app.buttons["NEW RENOVATION 2"].exists, "The new renovation name should be visible in the list.")
    }
}
