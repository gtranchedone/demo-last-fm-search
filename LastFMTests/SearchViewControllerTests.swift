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
        let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        viewController = initialViewController as? SearchViewController
        mockService = MockSearchService()
        viewController.searchService = mockService
        viewController.imageService = MockImageService()
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func test_is_delegate_of_searchBar() {
        XCTAssertTrue(viewController.searchBar?.delegate === viewController)
    }

    func test_has_contentViewController() {
        XCTAssertNotNil(viewController.contentViewController)
        XCTAssertTrue(viewController.contentViewController.delegate === viewController)
        XCTAssertNotNil(viewController.contentViewController?.imageService as? MockImageService)
    }
    
    func test_can_override_contentViewController() {
        let albumsViewController = AlbumsViewController()
        viewController.contentViewController = albumsViewController
        XCTAssertEqual(viewController.contentViewController, albumsViewController)
        XCTAssertTrue(viewController.contentViewController.delegate === viewController)
    }
    
    func test_passes_imageService_to_contentViewController_when_reset() {
        let albumsViewController = AlbumsViewController()
        viewController.contentViewController = albumsViewController
        viewController.imageService = MockImageService()
        XCTAssertNotNil(viewController.contentViewController?.imageService as? MockImageService)
        XCTAssertTrue(viewController.contentViewController.delegate === viewController)
    }
    
    func test_calls_searchService_on_search() {
        performSearchBarSearch()
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 1)
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.first, "Test 123")
    }
    
    func test_calls_searchService_on_search_no_text() {
        performSearchBarSearch(text: nil)
        XCTAssertEqual(mockService.recordedInvocations.searchAlbums.count, 0)
    }
    
    func test_loadingView_is_idle_before_performing_search() {
        XCTAssertEqual(viewController.loadingView.state, .idle)
    }
    
    func test_sets_loadingView_to_loading_when_performing_search() {
        viewController.searchService = nil
        performSearch(wait: false) {
            XCTAssertEqual(self.viewController.loadingView.state, .loading(message: "Loading"))
        }
    }
    
    func test_sets_loadingView_to_idle_after_performing_search_on_success() {
        mockService.stubbedResult.searchAlbums = .success([AlbumSummary.Builder().build()])
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
    
    func test_sets_albums_to_contentViewController_after_performing_search_on_success() {
        let albums = [AlbumSummary.Builder().build()]
        mockService.stubbedResult.searchAlbums = .success(albums)
        performSearch()
        XCTAssertEqual(viewController.contentViewController.albums, albums)
    }
    
    func test_sets_albums_to_contentViewController_after_performing_search_on_success_no_result() {
        viewController.contentViewController.albums = [AlbumSummary.Builder().build()]
        let albums: [AlbumSummary] = []
        mockService.stubbedResult.searchAlbums = .success(albums)
        performSearch()
        XCTAssertEqual(viewController.contentViewController.albums, albums)
    }
    
    func test_dismisses_keyboard_after_keyboard_search() {
        class MockSearchBar: UISearchBar {
            private(set) var didDismiss = false
            override func resignFirstResponder() -> Bool {
                didDismiss = true
                return super.resignFirstResponder()
            }
        }
        
        let mockSearchBar = MockSearchBar()
        viewController.searchBar = mockSearchBar
        performSearchBarSearch()
        XCTAssertTrue(mockSearchBar.didDismiss)
    }
    
    func test_dismisses_keyboard_after_keyboard_search_empty_text() {
        class MockSearchBar: UISearchBar {
            private(set) var didDismiss = false
            override func resignFirstResponder() -> Bool {
                didDismiss = true
                return super.resignFirstResponder()
            }
        }
        
        let mockSearchBar = MockSearchBar()
        viewController.searchBar = mockSearchBar
        performSearchBarSearch(text: nil)
        XCTAssertTrue(mockSearchBar.didDismiss)
    }
    
    func test_performs_segue_when_album_is_selected_in_contentViewController() {
        class MockViewController: SearchViewController {
            var performedSegueIdentifier: String?
            var performedSegueSender: Any?
            
            override func performSegue(withIdentifier identifier: String, sender: Any?) {
                performedSegueIdentifier = identifier
                performedSegueSender = sender
            }
        }
        
        let vc = MockViewController()
        let album = AlbumSummary.Builder().build()
        vc.albumsViewController(viewController.contentViewController, didSelectAlbum: album)
        XCTAssertEqual(vc.performedSegueIdentifier, SearchViewController.Segue.albumDetailsSegue.rawValue)
        XCTAssertEqual(vc.performedSegueSender as? AlbumSummary, album)
    }
    
    func test_prepareForSegue_configures_albumDetailsViewController_with_album_and_services() {
        let detailsViewController = AlbumDetailsViewController()
        let segue = UIStoryboardSegue(
            identifier: SearchViewController.Segue.albumDetailsSegue.rawValue,
            source: viewController,
            destination: detailsViewController
        )
        let album = AlbumSummary.Builder().build()
        viewController.prepare(for: segue, sender: album)
        XCTAssertEqual(detailsViewController.album, album)
        XCTAssertNotNil(detailsViewController.imageService as? MockImageService)
        XCTAssertNotNil(detailsViewController.searchService as? MockSearchService)
    }
    
    private func performSearch(text: String = "Test 123", wait: Bool = true, beforeWait: (() -> Void)? = nil) {
        let e = wait ? expectation(description: "Perform search") : nil
        viewController.search(text) {
            XCTAssertTrue(Thread.isMainThread)
            e?.fulfill()
        }
        beforeWait?()
        if wait {
            waitForExpectations(timeout: 10)
        }
    }
    
    private func performSearchBarSearch(text: String? = "Test 123") {
        let searchBar = viewController.searchBar ?? UISearchBar()
        searchBar.text = text
        viewController.searchBarSearchButtonClicked(searchBar)
    }

}
