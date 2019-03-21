//
//  AppDelegateTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
@testable import LastFM

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate!
    
    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        let window = UIWindow()
        window.rootViewController = UIStoryboard.main.instantiateInitialViewController()
        appDelegate.window = window
    }

    override func tearDown() {
        appDelegate = nil
        super.tearDown()
    }

    func test_configures_searchViewController_with_defaultService() {
        let didConfigure = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(didConfigure)
        let viewController = findSearchViewController()
        XCTAssertNotNil(viewController?.searchService as? LastFMSearchService)
        XCTAssertNotNil(viewController?.imageService as? DefaultImageService)
    }
    
    func test_fails_configuration_if_environment_does_not_contain_apiKey() throws {
        appDelegate.environment = try Environment(fileNamed: "broken_environment", bundle: .unitTests)
        let didConfigure = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(didConfigure)
        let viewController = findSearchViewController()
        XCTAssertNil(viewController?.searchService)
        XCTAssertNil(viewController?.imageService)
    }
    
    private func findSearchViewController() -> SearchViewController? {
        let navigationController = appDelegate.window?.rootViewController as? UINavigationController
        return navigationController?.topViewController as? SearchViewController
    }

}
