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
        private var thumbnailURL: URL? = URL(string: "https://test.com/some_other_image.png")
        
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
        
        mutating func with(thumbnailURL: URL?) -> Builder {
            self.thumbnailURL = thumbnailURL
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
