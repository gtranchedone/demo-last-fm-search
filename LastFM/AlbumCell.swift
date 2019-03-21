//
//  AlbumCell.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on margin1/03/margin019.
//  Copyright © margin019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    var cover: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    var artist: String? {
        set {
            artistLabel.text = newValue
        }
        get {
            return artistLabel.text
        }
    }
    
    private let titleLabel: UILabel = UILabel()
    private let artistLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    
    static let blurEffect = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blurEffect)
    let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        configureSubviews()
    }
    
    private func configureSubviews() {
        configureImageView()
        configureTitleLabel()
        configureArtistLabel()
        configureLabelsContainer()
        makeConstraints()
    }
    
    private func configureImageView() {
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }
    
    private func configureLabelsContainer() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(blurView)
        
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)
        
        vibrancyView.contentView.addSubview(titleLabel)
        vibrancyView.contentView.addSubview(artistLabel)
    }
    
    private func configureTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureArtistLabel() {
        artistLabel.numberOfLines = 2
        artistLabel.font = UIFont.preferredFont(forTextStyle: .body)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func makeConstraints() {
        let constraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            blurView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            vibrancyView.topAnchor.constraint(equalTo: blurView.topAnchor),
            vibrancyView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
            vibrancyView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: blurView.topAnchor, multiplier: 1),
            titleLabel.leftAnchor.constraint(equalToSystemSpacingAfter: blurView.leftAnchor, multiplier: 1),
            blurView.rightAnchor.constraint(equalToSystemSpacingAfter: titleLabel.rightAnchor, multiplier: 1),

            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            artistLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            artistLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            blurView.bottomAnchor.constraint(equalToSystemSpacingBelow: artistLabel.bottomAnchor, multiplier: 1)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
