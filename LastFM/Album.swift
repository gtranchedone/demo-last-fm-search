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
