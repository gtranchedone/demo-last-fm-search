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
        XCTAssertNotNil(viewController?.service as? LastFMSearchService)
    }
    
    private func findSearchViewController() -> SearchViewController? {
        let navigationController = appDelegate.window?.rootViewController as? UINavigationController
        return navigationController?.topViewController as? SearchViewController
    }

}
