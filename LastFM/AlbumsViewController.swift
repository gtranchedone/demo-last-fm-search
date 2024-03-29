//
//  AlbumsViewController.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 21/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

protocol AlbumsViewControllerDelegate: class {
    
    func albumsViewController(_ viewController: AlbumsViewController, didSelectAlbum album: AlbumSummary)
    
}

class AlbumsViewController: UIViewController {
    
    weak var delegate: AlbumsViewControllerDelegate?
    
    var albums: [AlbumSummary] = [] {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    var imageService: ImageService? {
        didSet {
            viewModel.imageService = imageService
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let itemWidth = (view.bounds.width - 30) / 2
        let itemHeight = itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return collectionView
    }()
    
    private let viewModel = AlbumsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.imageService = imageService
        viewModel.configure(collectionView: collectionView)
        collectionView.reloadData()
    }
    
    private func album(at indexPath: IndexPath) -> AlbumSummary {
        return albums[indexPath.item]
    }
    
}

extension AlbumsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = self.album(at: indexPath)
        return viewModel.dequeCell(for: album, at: indexPath, collectionView: collectionView)
    }
    
}

extension AlbumsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.albumsViewController(self, didSelectAlbum: album(at: indexPath))
    }
    
}
