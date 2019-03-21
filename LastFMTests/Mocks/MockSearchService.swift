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
        var searchAlbums: Result<[Album]> = .failure(Error.notAssigned)
    }
    
    struct RecordedInvocations {
        var searchAlbums: [String] = []
    }
    
    var stubbedResult = StubbedResult()
    private(set) var recordedInvocations = RecordedInvocations()
    
    func searchAlbums(query: String, completion: @escaping (Result<[Album]>) -> Void) {
        recordedInvocations.searchAlbums.append(query)
        completion(stubbedResult.searchAlbums)
    }
    
}
