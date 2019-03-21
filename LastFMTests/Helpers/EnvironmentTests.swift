//
//  EnvironmentTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
import LastFM

class EnvironmentTests: XCTestCase {

    var environment: Environment!
    
    override func setUp() {
        super.setUp()
        environment = try? Environment(fileNamed: "Environment.example",
                                       bundle: Bundle.unitTests)
    }

    override func tearDown() {
        environment = nil
        super.tearDown()
    }
    
    func test_init_throws_when_file_not_found() throws {
        XCTAssertThrowsError(try Environment(fileNamed: "Some file", bundle: .main))
    }

    func test_keys_stored_in_file() {
        XCTAssertEqual(environment["API_KEY"], "api_key")
    }
    
    func test_keys_not_stored_in_file() {
        XCTAssertNil(environment["SOME_KEY"])
    }

}
