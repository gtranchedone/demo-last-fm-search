//
//  Environment.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

/// A class that functions similarly to DotEnv in Javascript.
/// It uses a JSON format instead of KEY=VALUE lines.
/// I've decided to do so to simplify parsing and storage of the keys in Swift for this simple project.
public class Environment {
    
    private enum Error: Swift.Error {
        case fileNotFound
    }
    
    private let storage: [String: String]
    
    public subscript(key: String) -> String? {
        return value(forKey: key)
    }
    
    public init(fileNamed fileName: String = "Environment", bundle: Bundle = Bundle.main) throws {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            throw Error.fileNotFound
        }
        let data = try Data(contentsOf: fileURL)
        self.storage = try JSONDecoder().decode([String: String].self, from: data)
    }
    
    public func value(forKey key: String) -> String? {
        return storage[key]
    }
    
}
