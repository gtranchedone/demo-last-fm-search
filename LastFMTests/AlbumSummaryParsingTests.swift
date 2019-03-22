//
//  AlbumSummaryParsingTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumSummaryParsingTests: XCTestCase {
    
    func test_parsing_albums_from_search_extracts_correct_data() throws {
        let apiResponse: AlbumSearchResponse = try loadJSONFromFile(named: "search_albums")
        let albums = apiResponse.albums
        
        XCTAssertEqual(albums.count, 50)
        
        let first = albums.first
        XCTAssertEqual(first?.name, "Believe")
        XCTAssertEqual(first?.artist, "Disturbed")
        XCTAssertEqual(first?.coverURL, URL(string: "https://lastfm-img2.akamaized.net/i/u/174s/bca3b80481394e25b03f4fc77c338897.png"))
        
        let last = albums.last
        XCTAssertEqual(last?.name, "...Believes In Patterns")
        XCTAssertEqual(last?.artist, "I Would Set Myself on Fire for You")
        XCTAssertEqual(last?.coverURL, URL(string: "https://lastfm-img2.akamaized.net/i/u/174s/a82a75cfc7e34d60a39965f38f05e16b.png"))
    }
    
}
