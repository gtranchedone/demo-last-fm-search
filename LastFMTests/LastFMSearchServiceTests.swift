//
//  LastFMSearchServiceTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class LastFMSearchServiceTests: XCTestCase {

    var service: LastFMSearchService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = LastFMSearchService(apiKey: "api_key")
        service.session = mockSession
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func test_searchAlbums_requestsCorrectURL_andParameters() {
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything") { (result) in
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
        let recordedURLs = mockSession.recordedInvocations.task
        XCTAssertEqual(recordedURLs.count, 1)
        let expectedURLString = "https://ws.audioscrobbler.com/2.0/?album=Anything&api_key=api_key&format=json&method=album.search"
        XCTAssertEqual(recordedURLs[0], URL(string: expectedURLString))
    }
    
    func test_searchAlbums_requestsCorrectURL_andParameters_spaced_query() {
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything Else") { (result) in
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
        let recordedURLs = mockSession.recordedInvocations.task
        XCTAssertEqual(recordedURLs.count, 1)
        let expectedURLString = "https://ws.audioscrobbler.com/2.0/?album=Anything%20Else&api_key=api_key&format=json&method=album.search"
        XCTAssertEqual(recordedURLs[0], URL(string: expectedURLString))
    }
    
    func test_searchAlbums_requestsCorrectURL_andParameters_different_apiKey() {
        service = LastFMSearchService(apiKey: "other_api_key")
        service.session = mockSession
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything Else") { (result) in
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
        let recordedURLs = mockSession.recordedInvocations.task
        XCTAssertEqual(recordedURLs.count, 1)
        let expectedURLString = "https://ws.audioscrobbler.com/2.0/?album=Anything%20Else&api_key=other_api_key&format=json&method=album.search"
        XCTAssertEqual(recordedURLs[0], URL(string: expectedURLString))
    }

    func test_searchAlbums_data_ok() throws {
        let data = try loadDataFromFile(named: "search_albums")
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: data, response: nil, error: nil)
        let expectedResponse: AlbumSearchResponse = try loadJSONFromFile(named: "search_albums")
        let expectedAlbums = expectedResponse.albums
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything") { (result) in
            XCTAssertEqual(result, .success(expectedAlbums))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_searchAlbums_error() throws {
        struct SomeError: Error {}
        let error = SomeError()
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: nil, response: nil, error: error)
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything") { (result) in
            XCTAssertEqual(result, .failure(error))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_searchAlbums_emptyData() throws {
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: nil, response: nil, error: nil)
        let e = expectation(description: "Search for albums")
        service.searchAlbums(query: "Anything") { (result) in
            XCTAssertEqual(result, .failure(LastFMSearchService.Error.emptyData))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_searchAlbumDetails_requestsCorrectURL_andParameters() {
        let e = expectation(description: "Search for album details")
        service.searchAlbumDetails(album: AlbumSummary.Builder().build()) { (result) in
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
        let recordedURLs = mockSession.recordedInvocations.task
        XCTAssertEqual(recordedURLs.count, 1)
        let expectedURLString = "https://ws.audioscrobbler.com/2.0/?album=An%20album&artist=An%20artist&api_key=api_key&format=json&method=album.getinfo"
        XCTAssertEqual(recordedURLs[0], URL(string: expectedURLString))
    }
    
    func test_searchAlbumDetails_requestsCorrectURL_andParameters_different_apiKey() {
        service = LastFMSearchService(apiKey: "other_api_key")
        service.session = mockSession
        let e = expectation(description: "Search for album details")
        service.searchAlbumDetails(album: AlbumSummary.Builder().build()) { (result) in
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
        let recordedURLs = mockSession.recordedInvocations.task
        XCTAssertEqual(recordedURLs.count, 1)
        let expectedURLString = "https://ws.audioscrobbler.com/2.0/?album=An%20album&artist=An%20artist&api_key=other_api_key&format=json&method=album.getinfo"
        XCTAssertEqual(recordedURLs[0], URL(string: expectedURLString))
    }
    
    func test_searchAlbumDetails_data_ok() throws {
        let data = try loadDataFromFile(named: "album_details")
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: data, response: nil, error: nil)
        let expectedResponse: AlbumDetailsResponse = try loadJSONFromFile(named: "album_details")
        let expectedDetails = expectedResponse.details
        let e = expectation(description: "Search for album details")
        service.searchAlbumDetails(album: AlbumSummary.Builder().build()) { (result) in
            XCTAssertEqual(result, .success(expectedDetails))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_searchAlbumDetails_error() throws {
        struct SomeError: Error {}
        let error = SomeError()
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: nil, response: nil, error: error)
        let e = expectation(description: "Search for album details")
        service.searchAlbumDetails(album: AlbumSummary.Builder().build()) { (result) in
            XCTAssertEqual(result, .failure(error))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_searchAlbumDetails_emptyData() throws {
        mockSession.stubbbedResult = MockURLSession.StubbedResult(data: nil, response: nil, error: nil)
        let e = expectation(description: "Search for album details")
        service.searchAlbumDetails(album: AlbumSummary.Builder().build()) { (result) in
            XCTAssertEqual(result, .failure(LastFMSearchService.Error.emptyData))
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}
