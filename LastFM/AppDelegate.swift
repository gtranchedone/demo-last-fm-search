//
//  AppDelegate.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var environment = try? Environment()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSearchViewController()
        return true
    }
    
    private func configureSearchViewController() {
        guard let apiKey = environment?["API_KEY"] else {
            return
        }
        let navigationController = window?.rootViewController as? UINavigationController
        let viewController = navigationController?.topViewController as? SearchViewController
        viewController?.searchService = LastFMSearchService(apiKey: apiKey)
        viewController?.imageService = DefaultImageService()
    }

}
