//
//  Album+Builder.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

@testable import LastFM

extension Album {
    
    struct Builder {
        private var name: String = "An album"
        private var artist: String = "An artist"
        
        mutating func with(name: String) -> Builder {
            self.name = name
            return self
        }
        
        mutating func with(artist: String) -> Builder {
            self.artist = artist
            return self
        }
        
        func build() -> Album {
            return Album(
                name: self.name,
                artist: self.artist
            )
        }
    }
    
}
