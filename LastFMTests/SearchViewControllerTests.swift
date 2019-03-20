//
//  SearchViewControllerTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class SearchViewControllerTests: XCTestCase {

    var viewController: SearchViewController!
    
    override func setUp() {
        super.setUp()
        let identifier = "SearchViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? SearchViewController
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func test_calls_searchService_on_search() {
        let mockService = MockSearchService()
        viewController.service = mockService
        performSearch()
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 1)
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.first, "Test 123")
    }
    
    
    private func performSearch(text: String = "Test 123") {
        let searchBar = UISearchBar()
        searchBar.text = "Test 123"
        viewController.searchBarSearchButtonClicked(searchBar)
    }

}
