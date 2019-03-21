//
//  AlbumSearchResponse.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

struct AlbumSearchResponse: Codable {
    
    struct Result: Codable {
        
        struct Matches: Codable {
            
            let album: [Album]
            
        }
        
        let albummatches: Matches
    }
    
    let results: Result
    
}
