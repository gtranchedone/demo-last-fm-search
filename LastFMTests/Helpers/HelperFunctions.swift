//
//  JSONLoader.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

enum FileError: Error {
    case fileNotFound
}

func loadDataFromFile(named fileName: String) throws -> Data {
    guard let dataURL = Bundle.unitTests.url(forResource: fileName, withExtension: "json") else {
        throw FileError.fileNotFound
    }
    return try Data(contentsOf: dataURL)
}

func loadJSONFromFile<T: Codable>(named fileName: String) throws -> T {
    let albumsData = try loadDataFromFile(named: fileName)
    return try JSONDecoder().decode(T.self, from: albumsData)
}
