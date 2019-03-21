//
//  AlbumSearchResponse.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

/// This is the structure of the API response
struct AlbumSearchResponse: Codable {
    
    fileprivate enum ImageSize: String, Codable {
        case small
        case medium
        case large
        case extralarge
    }
    
    fileprivate struct Result: Codable {
        
        fileprivate struct Matches: Codable {
            
            fileprivate struct AlbumData: Codable {
                
                fileprivate struct ImageData: Codable {
                    let text: String
                    let size: ImageSize
                    
                    private enum CodingKeys : String, CodingKey {
                        case size, text = "#text"
                    }
                }
                
                let name: String
                let artist: String
                let image: [ImageData]
            }
            
            fileprivate let album: [AlbumData]
            
        }
        
        fileprivate let albummatches: Matches
    }
    
    private let results: Result
    
    /// Use this calculated property to make the API data into models the app understands
    var albums: [AlbumSummary] {
        return results.albummatches.album.map({ data in
            let coverURLString = data.image.filter({ $0.size == .large }).first
            let coverURL = coverURLString == nil ? nil : URL(string: coverURLString!.text)
            return AlbumSummary(
                name: data.name,
                artist: data.artist,
                coverURL: coverURL
            )
        })
    }
    
}
