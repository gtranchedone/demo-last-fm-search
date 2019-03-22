//
//  AlbumSearchResponse.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

fileprivate struct ImageData: Codable {
    
    fileprivate enum ImageSize: String, Codable {
        case small
        case medium
        case large
        case extralarge
        case mega
        case unknown = ""
    }
    
    let text: String
    let size: ImageSize
    
    private enum CodingKeys : String, CodingKey {
        case size, text = "#text"
    }
}

struct AlbumDetailsResponse: Codable {
    
    fileprivate struct Album: Codable {
        
        fileprivate struct TrackData: Codable {
            
            fileprivate struct Track: Codable {
                let duration: String
                let name: String
                let url: String
            }
            
            let track: [Track]
            
        }
        
        let name: String
        let artist: String
        let image: [ImageData]
        let tracks: TrackData
    }
    
    private let album: Album
    
    var details: AlbumDetails {
        let coverData = album.image.filter({ $0.size == .mega }).first
        let coverURL = coverData == nil ? nil : URL(string: coverData!.text)
        return AlbumDetails(
            name: album.name,
            artist: album.artist,
            coverURL: coverURL,
            tracks: album.tracks.track.map({
                AlbumDetails.Track(
                    duration: TimeInterval($0.duration) ?? 0,
                    name: $0.name,
                    url: URL(string: $0.url)
                )
            })
        )
    }
}

/// This is the structure of the API response
struct AlbumSearchResponse: Codable {
    
    fileprivate struct Result: Codable {
        
        fileprivate struct Matches: Codable {
            
            fileprivate struct AlbumData: Codable {
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
