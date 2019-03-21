//
//  LoadingViewTests.swift
//  LastFMTests
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

import XCTest
import LastFM

class LoadingViewTests: XCTestCase {
    
    var loadingView: LoadingView!
    
    override func setUp() {
        super.setUp()
        loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    }
    
    override func tearDown() {
        loadingView = nil
        super.tearDown()
    }
    
    func test_is_hidden_by_default_when_idle() {
        XCTAssertTrue(loadingView.hidesWhenIdle)
        XCTAssertTrue(loadingView.isHidden)
    }
    
    func test_is_hidden_by_default_when_becomes_idle() {
        loadingView.state = .loading(message: nil)
        loadingView.state = .idle
        XCTAssertTrue(loadingView.hidesWhenIdle)
        XCTAssertTrue(loadingView.isHidden)
    }
    
    func test_is_not_hidden_by_default_when_loading() {
        loadingView.state = .loading(message: nil)
        XCTAssertTrue(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_not_hidden_by_default_when_showing_error() {
        loadingView.state = .error(message: "Test", actionTitle: nil, actionHandler: nil)
        XCTAssertTrue(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_not_hidden_when_hidesWhenIdle_isFalse() {
        loadingView.hidesWhenIdle = false
        XCTAssertFalse(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_not_hidden_when_hidesWhenIdle_isFalse_and_becomes_idle() {
        loadingView.hidesWhenIdle = false
        loadingView.state = .loading(message: nil)
        loadingView.state = .idle
        XCTAssertFalse(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_not_hidden_when_hidesWhenIdle_isFalse_and_loading() {
        loadingView.hidesWhenIdle = false
        loadingView.state = .loading(message: nil)
        XCTAssertFalse(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_not_hidden_when_hidesWhenIdle_isFalse_and_showing_error() {
        loadingView.hidesWhenIdle = false
        loadingView.state = .error(message: "Test", actionTitle: nil, actionHandler: nil)
        XCTAssertFalse(loadingView.hidesWhenIdle)
        XCTAssertFalse(loadingView.isHidden)
    }
    
    func test_is_idle_by_default_with_correct_view_state() {
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == true)
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_idle() {
        loadingView.state = .idle
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == true)
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_loading_no_message() {
        loadingView.state = .loading(message: nil)
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == true)
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertFalse(activityIndicator?.isHidden == true)
    }
    
    func test_loading_with_message() {
        loadingView.state = .loading(message: "Test")
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == false)
        XCTAssertEqual(messageLabel?.text, "Test")
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertFalse(activityIndicator?.isHidden == true)
    }
    
    func test_error_no_message_no_actionTitle_no_actionHandler() {
        loadingView.state = .error(message: nil, actionTitle: nil, actionHandler: nil)
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == true)
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_error_with_message_no_actionTitle_no_actionHandler() {
        loadingView.state = .error(message: "Test", actionTitle: nil, actionHandler: nil)
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == false)
        XCTAssertEqual(messageLabel?.text, "Test")
        XCTAssertTrue(actionButton?.isHidden == true)
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_error_with_message_no_actionTitle_with_actionHandler() {
        loadingView.state = .error(message: "Test", actionTitle: nil, actionHandler: {})
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == false)
        XCTAssertEqual(messageLabel?.text, "Test")
        XCTAssertFalse(actionButton?.isHidden == true)
        XCTAssertEqual(actionButton?.title(for: .normal), nil)
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_error_with_message_with_actionTitle_with_actionHandler() {
        loadingView.state = .error(message: "Test", actionTitle: "Retry", actionHandler: {})
        let messageLabel = findMessageLabel()
        let actionButton = findActionButton()
        let activityIndicator = findActivityIndicatorView()
        XCTAssertTrue(messageLabel?.isHidden == false)
        XCTAssertEqual(messageLabel?.text, "Test")
        XCTAssertFalse(actionButton?.isHidden == true)
        XCTAssertEqual(actionButton?.title(for: .normal), "Retry")
        XCTAssertTrue(activityIndicator?.isHidden == true)
    }
    
    func test_error_tapping_actionButton_triggersHandler() {
        var didTapHandler = false
        loadingView.state = .error(message: "Test", actionTitle: "Retry", actionHandler: {
            didTapHandler = true
        })
        let actionButton = findActionButton()
        actionButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(didTapHandler)
    }
    
    private func findMessageLabel() -> UILabel? {
        return loadingView.viewWithTag(1) as? UILabel
    }
    
    private func findActionButton() -> UIButton? {
        return loadingView.viewWithTag(2) as? UIButton
    }
    
    private func findActivityIndicatorView() -> UIActivityIndicatorView? {
        return loadingView.viewWithTag(3) as? UIActivityIndicatorView
    }
    
}
