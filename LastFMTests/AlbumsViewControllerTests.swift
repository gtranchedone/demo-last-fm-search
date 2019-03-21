//
//  AlbumsViewControllerTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumsViewControllerTests: XCTestCase {

    var viewController: AlbumsViewController!
    var mockImageService: MockImageService!
    
    override func setUp() {
        super.setUp()
        mockImageService = MockImageService()
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "AlbumsViewController")
        viewController = vc as? AlbumsViewController
        let result: AlbumSearchResponse = try! loadJSONFromFile(named: "search_albums")
        viewController.albums = result.albums
        viewController.imageService = mockImageService
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func test_setting_albums_causes_collectionView_reload() {
        class MockCollectionView: UICollectionView {
            private(set) var didReload: Bool = false
            
            override func reloadData() {
                didReload = true
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        let mockCollectionView = MockCollectionView(frame: .zero, collectionViewLayout: layout)
        viewController.collectionView = mockCollectionView
        viewController.albums = []
        XCTAssertTrue(mockCollectionView.didReload)
    }
    
    func test_collection_view_data_source_number_of_sections() {
        XCTAssertEqual(viewController.collectionView.numberOfSections, 1)
    }
    
    func test_collection_view_data_source_number_of_items() {
        XCTAssertEqual(viewController.collectionView.numberOfItems(inSection: 0), 50)
    }
    
    func test_collection_view_data_source_cells() {
        viewController.albums = [AlbumSummary.Builder().build()]
        let indexPath = IndexPath(item: 0, section: 0)
        let collectionView = viewController.collectionView
        let cell = viewController.collectionView(collectionView, cellForItemAt: indexPath) as? AlbumCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.title, "An album")
        XCTAssertEqual(cell?.artist, "An artist")
        let image = UIImage(named: "believe.png", in: .unitTests, compatibleWith: nil)
        XCTAssertNotNil(image)
        let e = expectation(description: "Wait for cover to load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(cell?.cover?.pngData(), image?.pngData())
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_collection_view_data_source_cells_cachedImage() {
        let image = UIImage()
        mockImageService.cache(image, for: "https://test.com/cached.png")
        var builder = AlbumSummary.Builder()
        let album = builder.with(thumbnailURL: URL(string: "https://test.com/cached.png")!).build()
        viewController.albums = [album]
        let indexPath = IndexPath(item: 0, section: 0)
        let collectionView = viewController.collectionView
        let cell = viewController.collectionView(collectionView, cellForItemAt: indexPath) as? AlbumCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.title, "An album")
        XCTAssertEqual(cell?.artist, "An artist")
        XCTAssertNotNil(image)
        XCTAssertEqual(cell?.cover?.pngData(), image.pngData())
    }

}
