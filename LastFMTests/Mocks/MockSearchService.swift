//
//  MockSearchService.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import LastFM

class MockSearchService: SearchService {
    
    enum Error: Swift.Error {
        case notAssigned
    }
    
    struct StubbedResult {
        var searchAlbums: Result<[AlbumSummary]> = .failure(Error.notAssigned)
        var searchAlbumsDetails: Result<AlbumDetails> = .failure(Error.notAssigned)
    }
    
    struct RecordedInvocations {
        var searchAlbums: [String] = []
        var searchAlbumsDetails: [AlbumSummary] = []
    }
    
    var stubbedResult = StubbedResult()
    private(set) var recordedInvocations = RecordedInvocations()
    
    func searchAlbums(query: String, completion: @escaping (Result<[AlbumSummary]>) -> Void) {
        recordedInvocations.searchAlbums.append(query)
        DispatchQueue.global(qos: .background).async {
            completion(self.stubbedResult.searchAlbums)
        }
    }
    
    func searchAlbumDetails(album: AlbumSummary, completion: @escaping (Result<AlbumDetails>) -> Void) {
        recordedInvocations.searchAlbumsDetails.append(album)
        DispatchQueue.global(qos: .background).async {
            completion(self.stubbedResult.searchAlbumsDetails)
        }
    }
    
}
