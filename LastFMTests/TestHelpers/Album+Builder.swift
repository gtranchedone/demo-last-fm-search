//
//  Album+Builder.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation
@testable import LastFM

extension AlbumSummary {
    
    struct Builder {
        private var name: String = "An album"
        private var artist: String = "An artist"
        private var coverURL: URL? = URL(string: "https://test.com/some_image.png")
        
        mutating func with(name: String) -> Builder {
            self.name = name
            return self
        }
        
        mutating func with(artist: String) -> Builder {
            self.artist = artist
            return self
        }
        
        mutating func with(coverURL: URL?) -> Builder {
            self.coverURL = coverURL
            return self
        }
        
        func build() -> AlbumSummary {
            return AlbumSummary(
                name: self.name,
                artist: self.artist,
                coverURL: self.coverURL
            )
        }
    }
    
}

extension AlbumDetails {
    
    struct Builder {
        private var name: String = "An album"
        private var artist: String = "An artist"
        private var coverURL: URL? = URL(string: "https://test.com/some_image.png")
        private var tracks: [AlbumDetails.Track] = [
            AlbumDetails.Track(
                duration: 200,
                name: "Song 1",
                url: URL(string: "https://example.com/song_1")
            ),
            AlbumDetails.Track(
                duration: 300,
                name: "Song 2",
                url: URL(string: "https://example.com/song_2")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 3",
                url: URL(string: "https://example.com/song_3")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 4",
                url: URL(string: "https://example.com/song_4")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 5",
                url: URL(string: "https://example.com/song_5")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 6",
                url: URL(string: "https://example.com/song_6")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 7",
                url: URL(string: "https://example.com/song_7")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 8",
                url: URL(string: "https://example.com/song_8")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 9",
                url: URL(string: "https://example.com/song_9")
            ),
            AlbumDetails.Track(
                duration: 200,
                name: "Song 10",
                url: URL(string: "https://example.com/song_10")
            )
        ]
        
        mutating func with(name: String) -> Builder {
            self.name = name
            return self
        }
        
        mutating func with(artist: String) -> Builder {
            self.artist = artist
            return self
        }
        
        mutating func with(coverURL: URL?) -> Builder {
            self.coverURL = coverURL
            return self
        }
        
        mutating func with(tracks: [Track]) -> Builder {
            self.tracks = tracks
            return self
        }
        
        func build() -> AlbumDetails {
            return AlbumDetails(
                name: self.name,
                artist: self.artist,
                coverURL: self.coverURL,
                tracks: self.tracks
            )
        }
    }
    
}
