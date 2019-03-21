//
//  AlbumsViewModel.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class AlbumsViewModel {
    
    private enum CellIdentifier: String {
        case standardAlbum
    }
    
    var imageService: ImageService?
    
    func configure(collectionView: UICollectionView) {
        let identifier = CellIdentifier.standardAlbum.rawValue
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeCell(for album: AlbumSummary, at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let identifier = CellIdentifier.standardAlbum.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let theCell = cell as? AlbumCell {
            theCell.cover = nil
            theCell.title = album.name
            theCell.artist = album.artist
            if let coverURL = album.coverURL {
                fetchImage(url: coverURL, for: theCell, at: indexPath, collectionView: collectionView)
            }
        }
        return cell
    }
    
    private func fetchImage(url: URL, for cell: AlbumCell, at indexPath: IndexPath, collectionView: UICollectionView) {
        cell.cover = imageService?.fetchImage(from: url) { (result) in
            DispatchQueue.main.async {
                let currentIndexPath = collectionView.indexPath(for: cell)
                if case let .success(image) = result, currentIndexPath == nil || currentIndexPath == indexPath {
                    cell.cover = image
                }
            }
        }
    }
    
}
