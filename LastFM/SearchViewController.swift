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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        service?.searchAlbums(query: text, completion: { (result) in
            // TODO: implement me
        })
    }
    
}

