//
//  MockURLSession.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation
import LastFM

class MockTask: URLSessionTaskProtocol {
    
    let completionHandler: () -> Void
    
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    func resume() {
        self.completionHandler()
    }
    
}

class MockURLSession: URLSessionProtocol {
    
    struct StubbedResult {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    struct RecordedInvocations {
        var task: [URL] = []
    }
    
    var stubbbedResult = StubbedResult(data: nil, response: nil, error: nil)
    private(set) var recordedInvocations = RecordedInvocations()
    
    func task(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        recordedInvocations.task.append(url)
        let result = stubbbedResult
        return MockTask(completionHandler: {
            completionHandler(result.data, result.response, result.error)
        })
    }
    
}
