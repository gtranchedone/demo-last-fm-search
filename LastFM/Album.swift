//
//  Album.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

public struct AlbumSummary {
    let name: String
    let artist: String
    let coverURL: URL?
}

extension AlbumSummary: Equatable {}

public struct AlbumDetails {
    
    public struct Track {
        let duration: TimeInterval
        let name: String
        let url: URL?
    }
    
    let name: String
    let artist: String
    let coverURL: URL?
    let tracks: [Track]
}

extension AlbumDetails: Equatable {}
extension AlbumDetails.Track: Equatable {}
