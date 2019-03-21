//
//  URLSessionProtocolTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest

class URLSessionProtocolTests: XCTestCase {

    func test_URLSession_conforms_to_URLSessionProtocol() {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://apple.com")!
        let task = session.task(with: url, completionHandler: { _, _, _ in })
        XCTAssertNotNil(task as? URLSessionDataTask)
    }

}
