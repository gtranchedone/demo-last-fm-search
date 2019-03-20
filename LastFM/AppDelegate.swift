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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSearchViewController()
        return true
    }
    
    private func configureSearchViewController() {
        let navigationController = window?.rootViewController as? UINavigationController
        let viewController = navigationController?.topViewController as? SearchViewController
        viewController?.service = LastFMSearchService()
    }

}

