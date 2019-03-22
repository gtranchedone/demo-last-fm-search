//
//  MockExternalURLService.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit
@testable import LastFM

class MockExternalURLService: ExternalURLService {
    
    struct StubbedResults {
        var canOpenURL: Bool = true
    }
    
    struct RecordedInvocations {
        var canOpenURL: [URL] = []
        var openURL: [(url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler: ((Bool) -> Void)?)] = []
    }
    
    var stubbedResults = StubbedResults()
    private(set) var recordedInvocations = RecordedInvocations()
    
    func canOpenURL(_ url: URL) -> Bool {
        recordedInvocations.canOpenURL.append(url)
        return stubbedResults.canOpenURL
    }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        recordedInvocations.openURL.append((url: url, options: options, completionHandler: completion))
    }
    
}
