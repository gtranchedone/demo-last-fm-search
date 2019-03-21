//
//  SearchViewController.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public protocol SearchService {
    
    func searchAlbums(query: String, completion: @escaping (Result<[Album]>) -> Void)
    
}

class SearchViewController: UIViewController {

    var service: SearchService?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: LoadingView!
    weak var contentViewController: AlbumsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController = children.first as? AlbumsViewController
    }
    
    func search(_ text: String, completion: (() -> Void)? = nil) {
        loadingView.state = .loading(message: "Loading")
        service?.searchAlbums(query: text, completion: { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleSearchResult(result, searchTerm: text)
                completion?()
            }
        })
    }
    
    private func handleSearchResult(_ result: Result<[Album]>, searchTerm: String) {
        switch result {
            case .success(let albums):
                handleSearchSuccess(albums: albums)
            
            case .failure(let error):
                handleSearchFailure(searchTerm: searchTerm, error: error)
        }
    }
    
    private func handleSearchSuccess(albums: [Album]) {
        if albums.isEmpty {
            loadingView.state = .error(
                message: "No results",
                actionTitle: nil,
                actionHandler: nil
            )
        }
        else {
            loadingView.state = .idle
        }
        contentViewController.albums = albums
    }
    
    private func handleSearchFailure(searchTerm: String, error: Error) {
        loadingView.state = .error(
            message: "An error has occurred",
            actionTitle: "Retry",
            actionHandler: { [weak self] in
                self?.search(searchTerm)
            }
        )
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        search(text)
    }
    
}

