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
        case baseURLString = "https://ws.audioscrobbler.com/2.0/"
    }
    
    let apiKey: String
    var session: URLSessionProtocol = URLSession.shared
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func searchAlbums(query: String, completion: @escaping (Result<[AlbumSummary]>) -> Void) {
        guard let url = try? composeURLForAlbumSearch(query: query) else { return }
        fetchData(url: url, completion: { (result: Result<AlbumSearchResponse>) in
            completion(result.map({ $0.albums }))
        })
    }
    
    func searchAlbumDetails(album: AlbumSummary, completion: @escaping (Result<AlbumDetails>) -> Void) {
        guard let url = try? composeURLForAlbumDetailsSearch(album: album) else { return }
        fetchData(url: url, completion: { (result: Result<AlbumDetailsResponse>) in
            completion(result.map({ $0.details }))
        })
    }
    
    private func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T>) -> Void) {
        let task = session.task(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            do {
                let result: T = try self.parseResponse((data, response, error))
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func composeURLForAlbumSearch(query: String) throws -> URL {
        let queryItems = [
            URLQueryItem(name: "album", value: query),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "method", value: "album.search")
        ]
        return try composeURL(base: Endpoints.baseURLString.rawValue, queryItems: queryItems)
    }
    
    private func composeURLForAlbumDetailsSearch(album: AlbumSummary) throws -> URL {
        let queryItems = [
            URLQueryItem(name: "album", value: album.name),
            URLQueryItem(name: "artist", value: album.artist),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "method", value: "album.getinfo")
        ]
        return try composeURL(base: Endpoints.baseURLString.rawValue, queryItems: queryItems)
    }
    
    private func composeURL(base: String, queryItems: [URLQueryItem]) throws -> URL {
        var urlComponents = URLComponents(string: base)
        urlComponents?.queryItems = queryItems
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
