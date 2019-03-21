//
//  ResultTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
import LastFM

class ResultTests: XCTestCase {
    
    enum Error: Swift.Error {
        case foo
        case bar
    }

    func test_results_with_same_value_are_equal() {
        let lhs = Result<Int>.success(0)
        let rhs = Result<Int>.success(0)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_results_with_different_values_are_not_equal() {
        let lhs = Result<Int>.success(0)
        let rhs = Result<Int>.success(1)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_results_with_same_error_are_equal() {
        let lhs = Result<Int>.failure(Error.foo)
        let rhs = Result<Int>.failure(Error.foo)
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_results_with_different_errors_are_not_equal() {
        let lhs = Result<Int>.failure(Error.foo)
        let rhs = Result<Int>.failure(Error.bar)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_results_of_different_kind_are_not_equal() {
        let lhs = Result<Int>.success(0)
        let rhs = Result<Int>.failure(Error.foo)
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_map_value() {
        let r = Result<Int>.success(1)
        let lhs = r.map({ String(describing: $0) })
        let rhs = Result<String>.success("1")
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_map_error() {
        let r = Result<Int>.failure(Error.foo)
        let lhs = r.map({ String(describing: $0) })
        let rhs = Result<String>.failure(Error.foo)
        XCTAssertEqual(lhs, rhs)
    }

}
