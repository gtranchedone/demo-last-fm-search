//
//  DefaultImageService.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class DefaultImageService: ImageService {
    
    private enum Error: Swift.Error {
        case invalidImageData
    }
    
    private var cache = NSCache<NSURL, UIImage>()
    
    func fetchImage(from url: URL, completionHandler: @escaping (Result<UIImage>) -> Void) -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completionHandler(.failure(Error.invalidImageData))
                    return
                }
                self?.cache.setObject(image, forKey: url as NSURL)
                completionHandler(.success(image))
            }
            catch {
                completionHandler(.failure(error))
            }
        }
        return nil
    }
    
}
