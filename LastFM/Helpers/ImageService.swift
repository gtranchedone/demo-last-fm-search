//
//  ImageService.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

protocol ImageService {
    
    func fetchImage(from url: URL, completionHandler: @escaping (Result<UIImage>) -> Void) -> UIImage?
    
}
