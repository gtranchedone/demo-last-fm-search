//
//  URLSessionProtocol.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

public protocol URLSessionTaskProtocol {
    
    func resume()
    
}

extension URLSessionDataTask: URLSessionTaskProtocol {}

public protocol URLSessionProtocol {
    
    func task(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol
    
}

extension URLSession: URLSessionProtocol {
    
    public func task(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler)
    }
    
}
