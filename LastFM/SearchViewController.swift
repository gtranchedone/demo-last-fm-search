//
//  SearchViewController.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public protocol SearchService {
    
    func searchAlbums(query: String, completion: @escaping (Result<[AlbumSummary]>) -> Void)
    func searchAlbumDetails(album: AlbumSummary, completion: @escaping (Result<AlbumDetails>) -> Void)
    
}

class SearchViewController: UIViewController {

    enum Segue: String {
        case albumDetailsSegue = "AlbumDetailsSegue"
    }
    
    var searchService: SearchService?
    var imageService: ImageService? {
        didSet {
            contentViewController?.imageService = imageService
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: LoadingView!
    weak var contentViewController: AlbumsViewController! {
        didSet {
            contentViewController?.imageService = imageService
            contentViewController?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewController = children.first as? AlbumsViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.albumDetailsSegue.rawValue {
            let detailsViewController = segue.destination as? AlbumDetailsViewController
            detailsViewController?.searchService = searchService
            detailsViewController?.imageService = imageService
            detailsViewController?.album = sender as? AlbumSummary
        }
    }
    
}

extension SearchViewController {
    
    func search(_ text: String, completion: (() -> Void)? = nil) {
        loadingView.state = .loading(message: "Loading")
        searchService?.searchAlbums(query: text, completion: { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleSearchResult(result, searchTerm: text)
                completion?()
            }
        })
    }
    
    private func handleSearchResult(_ result: Result<[AlbumSummary]>, searchTerm: String) {
        switch result {
            case .success(let albums):
                handleSearchSuccess(albums: albums)
            
            case .failure(let error):
                handleSearchFailure(searchTerm: searchTerm, error: error)
        }
    }
    
    private func handleSearchSuccess(albums: [AlbumSummary]) {
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

extension SearchViewController: AlbumsViewControllerDelegate {
    
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum album: AlbumSummary) {
        performSegue(withIdentifier: Segue.albumDetailsSegue.rawValue, sender: album)
    }
    
}
