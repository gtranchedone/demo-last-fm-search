//
//  AlbumSearchResponse.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    
    struct Album: Codable {
        let name: String
    }
    
    private let album: Album
    
    var details: AlbumDetails {
        return AlbumDetails(
            name: "Album",
            artist: "Artist",
            coverURL: URL(string: "https://example.com/cover.png"),
            tracks: [
                AlbumDetails.Track(
                    duration: 200,
                    name: "Song 1",
                    url: URL(string: "https://example.com/song_1")
                ),
                AlbumDetails.Track(
                    duration: 200,
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
        )
    }
}

/// This is the structure of the API response
struct AlbumSearchResponse: Codable {
    
    fileprivate enum ImageSize: String, Codable {
        case small
        case medium
        case large
        case extralarge
        case mega
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
