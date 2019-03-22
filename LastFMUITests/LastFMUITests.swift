//
//  LastFMUITests.swift
//  LastFMUITests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest

class LastFMUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func test_happy_path() {
        XCTAssertTrue(app.navigationBars["LastFM Search"].exists)
        let searchField = app.searchFields["Search album"]
        searchField.tap()
        searchField.typeText("Thriller")
        app.keyboards.buttons["Search"].tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["Thriller"].exists)
        app.tables.cells.staticTexts["Beat It"].tap()
    }

}
