//
//  AlbumDetailsViewControllerTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumDetailsViewControllerTests: XCTestCase {

    var mockImageService: MockImageService!
    var mockSearchService: MockSearchService!
    var viewController: AlbumDetailsViewController!
    
    override func setUp() {
        super.setUp()
        mockImageService = MockImageService()
        mockSearchService = MockSearchService()
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "AlbumDetailsViewController")
        viewController = vc as? AlbumDetailsViewController
        viewController.searchService = mockSearchService
        viewController.imageService = mockImageService
        viewController.album = AlbumSummary.Builder().build()
    }

    override func tearDown() {
        viewController = nil
        mockImageService = nil
        mockSearchService = nil
        super.tearDown()
    }

    func test_sets_title_to_album_title() {
        XCTAssertEqual(viewController.title, "An album")
    }
    
    func test_sets_title_to_album_title_2() {
        var builder = AlbumSummary.Builder()
        let album = builder.with(name: "Another album").build()
        viewController.album = album
        XCTAssertEqual(viewController.title, "Another album")
    }
    
    // MARK: Songs Table View
    
    func test_table_background_is_loadingView() {
        XCTAssertNotNil(viewController.tableView.backgroundView as? LoadingView)
    }
    
    func test_loadingView_is_error_if_album_is_nil() {
        viewController.album = nil
        let loadingView = viewController.tableView.backgroundView as? LoadingView
        let expectedState = LoadingView.State.error(
            message: "No album selected",
            actionTitle: nil,
            actionHandler: nil
        )
        XCTAssertEqual(loadingView?.state, expectedState)
    }
    
    func test_loadingView_is_loading_before_content_is_loaded() {
        let loadingView = viewController.tableView.backgroundView as? LoadingView
        XCTAssertEqual(loadingView?.state, .loading(message: "Loading"))
    }
    
    func test_loadingView_is_idle_after_content_is_loaded_successfully() {
        configureMocksForSuccessAndLoadView()
        let loadingView = viewController.tableView.backgroundView as? LoadingView
        XCTAssertEqual(loadingView?.state, .idle)
    }
    
    func test_loadingView_is_error_after_content_is_loaded_with_failure() {
        loadViewAndWaitForDataToLoad()
        let loadingView = viewController.tableView.backgroundView as? LoadingView
        let expectedState = LoadingView.State.error(
            message: "An error has occurred",
            actionTitle: "Retry",
            actionHandler: nil
        )
        XCTAssertEqual(loadingView?.state, expectedState)
    }
    
    func test_table_header_is_nil_before_content_is_loaded() {
        viewController.searchService = nil
        XCTAssertNil(viewController.tableView.tableHeaderView)
    }
    
    func test_table_header_is_imageView_after_content_is_loaded() {
        loadViewAndWaitForDataToLoad()
        XCTAssertNotNil(viewController.tableView.tableHeaderView as? UIImageView)
    }
    
    func test_table_header_containsCorrectImage_after_content_is_loaded() {
        configureMocksForSuccessAndLoadView()
        let expectedImage = UIImage(named: "believe", in: .unitTests, compatibleWith: nil)
        let imageView = viewController.tableView.tableHeaderView as? UIImageView
        XCTAssertEqual(expectedImage?.pngData(), imageView?.image?.pngData())
    }
    
    func test_has_one_section_to_display_songs() {
        XCTAssertEqual(viewController.tableView.numberOfSections, 1)
    }
    
    func test_shows_no_songs_before_content_is_loaded() {
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_shows_all_songs_after_content_is_loaded() {
        configureMocksForSuccessAndLoadView()
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 10)
    }
    
    func test_shows_detail_for_each_song() {
        configureMocksForSuccessAndLoadView()
        let tableView = viewController.tableView!
        let cell1 = viewController.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell1.textLabel?.text, "Song 1")
        XCTAssertEqual(cell1.detailTextLabel?.text, "3:20")
        let cell2 = viewController.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertEqual(cell2.textLabel?.text, "Song 2")
        XCTAssertEqual(cell2.detailTextLabel?.text, "5:00")
    }
    
    private func configureMocksForSuccessAndLoadView() {
        mockSearchService.stubbedResult.searchAlbumsDetails = .success(AlbumDetails.Builder().build())
        loadViewAndWaitForDataToLoad()
    }
    
    private func loadViewAndWaitForDataToLoad() {
        viewController.loadViewIfNeeded()
        waitForAsyncJobToComplete()
    }
    
    private func waitForAsyncJobToComplete() {
        let e = expectation(description: "Load album details")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            e.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

}
