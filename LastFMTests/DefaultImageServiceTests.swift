//
//  DefaultImageServiceTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit
import XCTest
@testable import LastFM

class DefaultImageServiceTests: XCTestCase {
    
    var service: DefaultImageService!
    
    override func setUp() {
        super.setUp()
        service = DefaultImageService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func test_loads_image_from_url() throws {
        let imageURL = Bundle.unitTests.url(forResource: "believe", withExtension: "png")!
        let data = try Data(contentsOf: imageURL)
        let image = UIImage(data: data)
        let e = expectation(description: "Load image")
        let cached = service.fetchImage(from: imageURL) { (result) in
            if case let .success(returnedImage) = result {
                XCTAssertEqual(returnedImage.pngData(), image?.pngData())
                e.fulfill()
            }
        }
        XCTAssertNil(cached)
        waitForExpectations(timeout: 10)
    }
    
    func test_loads_image_from_cache() throws {
        let imageURL = Bundle.unitTests.url(forResource: "believe", withExtension: "png")!
        let data = try Data(contentsOf: imageURL)
        let image = UIImage(data: data)
        let e = expectation(description: "Load image")
        let cachedBefore = service.fetchImage(from: imageURL) { (result) in
            e.fulfill()
        }
        XCTAssertNil(cachedBefore)
        waitForExpectations(timeout: 10)
        let cachedAfter = service.fetchImage(from: imageURL) { _ in }
        XCTAssertNotNil(cachedAfter)
        XCTAssertEqual(cachedAfter?.pngData(), image?.pngData())
    }
    
    func test_failes_for_image_not_found() throws {
        var imageURL = Bundle.unitTests.url(forResource: "believe", withExtension: "png")!
        let newURLString = imageURL.absoluteString.replacingOccurrences(of: "believe", with: "faith")
        imageURL = URL(string: newURLString)!
        let e = expectation(description: "Load image")
        _ = service.fetchImage(from: imageURL) { (result) in
            if case .failure(_) = result {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_failes_for_invalid_image_data() throws {
        let imageURL = Bundle.unitTests.url(forResource: "search_albums", withExtension: "json")!
        let e = expectation(description: "Load image")
        _ = service.fetchImage(from: imageURL) { (result) in
            if case .failure(_) = result {
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
}
