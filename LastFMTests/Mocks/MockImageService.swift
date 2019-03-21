//
//  MockImageService.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit
@testable import LastFM

class MockImageService: ImageFetcher {
    
    private enum Error: Swift.Error {
        case notFound
    }
    
    private let imagesMap = [
        "https://test.com/some_image.png": "believe",
        "https://test.com/some_other_image.png": "believe"
    ]
    
    private var cache: [String: UIImage] = [:]
    
    func cache(_ image: UIImage, for key: String) {
        cache[key] = image
    }
    
    func fetchImage(from url: URL, completionHandler: @escaping (Result<UIImage>) -> Void) -> UIImage? {
        if let cached = cache[url.absoluteString] {
            return cached
        }
        guard
            let imageName = imagesMap[url.absoluteString],
            let imageURL = Bundle.unitTests.url(forResource: imageName, withExtension: "png"),
            let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data) else {
            completionHandler(.failure(Error.notFound))
            return nil
        }
        DispatchQueue.global(qos: .background).async {
            completionHandler(.success(image))
        }
        return nil
    }
    
}
