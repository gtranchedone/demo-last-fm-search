//
//  LastFMSearchService.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import Foundation

class LastFMSearchService: SearchService {
    
    enum Error: Swift.Error {
        case cannotCreateURL
        case emptyData
    }
    
    private enum Endpoints: String {
        case albumSearch = "https://ws.audioscrobbler.com/2.0/"
    }
    
    let apiKey: String
    var session: URLSessionProtocol = URLSession.shared
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func searchAlbums(query: String, completion: @escaping (Result<[AlbumSummary]>) -> Void) {
        do {
            let url = try composeURLForAlbumSearch(query: query)
            let task = session.task(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                do {
                    let result: AlbumSearchResponse = try self.parseResponse((data, response, error))
                    completion(.success(result.albums))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        catch {
            completion(.failure(error))
        }
    }
    
    private func composeURLForAlbumSearch(query: String) throws -> URL {
        var urlComponents = URLComponents(string: Endpoints.albumSearch.rawValue)
        urlComponents?.queryItems = [
            URLQueryItem(name: "album", value: query),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "method", value: "album.search"),
        ]
        guard let url = urlComponents?.url else {
            throw Error.cannotCreateURL
        }
        return url
    }
    
    private func parseResponse<T: Codable>(_ response: (Data?, URLResponse?, Swift.Error?)) throws -> T {
        let (data, _, error) = response
        if let error = error {
            throw error
        }
        guard let theData = data else {
            throw Error.emptyData
        }
        return try JSONDecoder().decode(T.self, from: theData)
    }
    
}
