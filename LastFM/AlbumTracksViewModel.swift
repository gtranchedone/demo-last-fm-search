//
//  AlbumTracksViewModel.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 22/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class AlbumTracksViewModel {
    
    private enum CellIdentifier: String {
        case albumTrackCell = "AlbumTrackCell"
    }
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    func cell(for track: AlbumDetails.Track, at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let identifer = CellIdentifier.albumTrackCell.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath)
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = timeFormatter.string(from: track.duration)
        return cell
    }
}
