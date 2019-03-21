//
//  Bundle+Helpers.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var unitTests: Bundle {
        class BundleFinder {}
        return Bundle(for: BundleFinder.self)
    }
    
}
