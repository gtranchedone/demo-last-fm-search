//
//  LoadingView.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    
    public enum State {
        case idle
        case loading(message: String?)
        case error(message: String?, actionTitle: String?, actionHandler: (() -> Void)?)
    }
    
    public var state: State = .idle {
        didSet {
            updateViewState()
        }
    }
    
    private var messageLabel = UILabel()
    private var actionButton = UIButton(type: .system)
    private var activityIndicator = { () -> UIActivityIndicatorView in
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.tag = 1 // make it searchable in tests
        
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        actionButton.tag = 2 // make it searchable in tests
        
        activityIndicator.tag = 3 // make it searchable in tests
        
        let margin: CGFloat = 10
        let containerView = UIView()
        addSubview(containerView)
        
        let arrangedViews = [messageLabel, actionButton, activityIndicator]
        let stackView = UIStackView(arrangedSubviews: arrangedViews)
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = margin
        containerView.addSubview(stackView)
        
        let constraints = [
            // stackView container
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // stackView
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: margin),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -margin),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -margin),
            
            // stackView content
            messageLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        
        updateViewState()
    }
    
    private func updateViewState() {
        switch state {
            case .idle:
                messageLabel.isHidden = true
                actionButton.isHidden = true
                activityIndicator.stopAnimating()
            
            case .loading(message: let message):
                messageLabel.isHidden = message == nil
                messageLabel.text = message
                actionButton.isHidden = true
                activityIndicator.startAnimating()
            
            case .error(let message, let actionTitle, let actionHandler):
                messageLabel.isHidden = message == nil
                messageLabel.text = message
                actionButton.isHidden = actionHandler == nil
                actionButton.setTitle(actionTitle, for: .normal)
                activityIndicator.stopAnimating()
        }
    }
    
    @objc
    private func didTapActionButton() {
        if case .error(_, _, let actionHandler) = state {
            actionHandler?()
        }
    }
    
}
