//
//  AlbumDetailsParsingTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class AlbumDetailsParsingTests: XCTestCase {

    func test_parsing_album_details_extracts_correct_data() throws {
        let apiResponse: AlbumDetailsResponse = try loadJSONFromFile(named: "album_details")
        let album = apiResponse.details
        
        XCTAssertEqual(album.name, "Believe")
        XCTAssertEqual(album.artist, "Cher")
        XCTAssertEqual(album.coverURL, URL(string: "https://lastfm-img2.akamaized.net/i/u/300x300/3b54885952161aaea4ce2965b2db1638.png"))
        
        XCTAssertEqual(album.tracks.count, 10)
        
        let firstTrack = album.tracks.first
        XCTAssertEqual(firstTrack?.duration, 237)
        XCTAssertEqual(firstTrack?.name, "Believe")
        XCTAssertEqual(firstTrack?.url, URL(string: "https://www.last.fm/music/Cher/_/Believe"))
        
        let lastTrack = album.tracks.last
        XCTAssertEqual(lastTrack?.duration, 231)
        XCTAssertEqual(lastTrack?.name, "We All Sleep Alone")
        XCTAssertEqual(lastTrack?.url, URL(string: "https://www.last.fm/music/Cher/_/We+All+Sleep+Alone"))
    }

}
