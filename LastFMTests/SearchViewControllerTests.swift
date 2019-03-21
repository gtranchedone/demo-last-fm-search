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
    var mockService: MockSearchService!
    
    override func setUp() {
        super.setUp()
        let identifier = "SearchViewController"
        let storyboard = UIStoryboard.main
        viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? SearchViewController
        mockService = MockSearchService()
        viewController.service = mockService
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func test_calls_searchService_on_search() {
        performSearch()
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 1)
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.first, "Test 123")
    }
    
    func test_calls_searchService_on_search_no_text() {
        performSearch(text: nil)
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 0)
    }
    
    func test_loadingView_is_idle_before_performing_search() {
        XCTAssertEqual(viewController.loadingView.state, .idle)
    }
    
    func test_sets_loadingView_to_loading_when_performing_search() {
        viewController.service = nil
        performSearch()
        XCTAssertEqual(viewController.loadingView.state, .loading(message: "Loading"))
    }
    
    func test_sets_loadingView_to_idle_after_performing_search_on_success() {
        mockService.stubbedResult.searchAlbums = .success([Album(name: "An album")])
        performSearch()
        XCTAssertEqual(viewController.loadingView.state, .idle)
    }
    
    func test_sets_loadingView_to_error_after_performing_search_on_success_no_result() {
        mockService.stubbedResult.searchAlbums = .success([])
        performSearch()
        XCTAssertEqual(viewController.loadingView.state,
                       .error(message: "No results", actionTitle: nil, actionHandler: nil))
    }
    
    func test_sets_loadingView_to_error_after_performing_search_on_failure() {
        mockService.stubbedResult.searchAlbums = .failure(MockSearchService.Error.notAssigned)
        performSearch()
        XCTAssertEqual(viewController.loadingView.state,
                       .error(message: "An error has occurred", actionTitle: "Retry", actionHandler: nil))
    }
    
    func test_can_retry_after_performing_failed_search() {
        mockService.stubbedResult.searchAlbums = .failure(MockSearchService.Error.notAssigned)
        performSearch()
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 1)
        guard case let .error(_, _, action) = viewController.loadingView.state else {
            XCTFail()
            return
        }
        action?()
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 2)
    }
    
    private func performSearch(text: String? = "Test 123") {
        let searchBar = UISearchBar()
        searchBar.text = text
        viewController.searchBarSearchButtonClicked(searchBar)
    }

}
