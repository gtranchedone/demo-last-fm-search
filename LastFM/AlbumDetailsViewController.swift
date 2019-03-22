//
//  AlbumDetailsViewController.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UITableViewController {

    var album: AlbumSummary? {
        didSet {
            title = album?.name
        }
    }
    var imageService: ImageService?
    var searchService: SearchService?
    var externalURLService: ExternalURLService = UIApplication.shared
    
    private var albumDetails: AlbumDetails?
    private let tracksViewModel = AlbumTracksViewModel()
    
    private var loadingView: LoadingView? {
        return tableView.backgroundView as? LoadingView
    }
    
    private var coverImageView: UIImageView? {
        return tableView.tableHeaderView as? UIImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = LoadingView(frame: tableView.bounds)
        reloadData()
    }
    
    private func reloadData() {
        guard let album = album else {
            loadingView?.state = .error(
                message: "No album selected",
                actionTitle: nil,
                actionHandler: nil
            )
            return
        }
        loadingView?.state = .loading(message: "Loading")
        searchService?.searchAlbumDetails(album: album) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.configureViewContent(for: result)
            }
        }
    }
    
    private func configureViewContent(for result: Result<AlbumDetails>) {
        let imageSize = view.bounds.width
        let coverFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        let albumCoverView = UIImageView(frame: coverFrame)
        albumCoverView.backgroundColor = .darkGray
        tableView.tableHeaderView = albumCoverView
        
        switch result {
            case .success(let details):
                loadingView?.state = .idle
                updateView(for: details)
            default:
                loadingView?.state = .error(
                    message: "An error has occurred",
                    actionTitle: "Retry",
                    actionHandler: nil
                )
                updateView(for: nil)
        }
    }
    
    private func updateView(for albumDetails: AlbumDetails?) {
        self.albumDetails = albumDetails
        if let coverURL = albumDetails?.coverURL {
            loadCover(from: coverURL)
        }
        tableView.reloadData()
    }
    
    private func loadCover(from url: URL) {
        coverImageView?.image = imageService?.fetchImage(from: url) { [weak self] (result) in
            guard let self = self, case let .success(image) = result else { return }
            DispatchQueue.main.async {
                self.coverImageView?.image = image
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetails?.tracks.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let track = albumDetails?.tracks[indexPath.row] else { abort() }
        return tracksViewModel.cell(for: track, at: indexPath, in: tableView)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let track = albumDetails?.tracks[indexPath.row], let url = track.url {
            if externalURLService.canOpenURL(url) {
                externalURLService.open(url, options: [:], completionHandler: nil)
            }
        }
    }
 
}
