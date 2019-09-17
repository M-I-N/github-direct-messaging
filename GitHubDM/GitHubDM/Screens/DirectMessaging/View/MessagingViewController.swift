//
//  MessagingViewController.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController {

    @IBOutlet private weak var messagesTableView: UITableView!
    @IBOutlet private weak var messageInputTextView: UITextView!
    
    @IBOutlet weak var messagesTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageInputBoxHeightConstraint: NSLayoutConstraint!
    
    var viewModel: MessagingViewModel!
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.titleFormattedAsGitHubHandle
        navigationItem.largeTitleDisplayMode = .never
        messageInputTextView.layer.cornerRadius = 20
        shouldStartHandlingViewForKeyboardAppearnce()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)

        messagesTableView.dataSource = self
        messagesTableView.registerReusableCell(OutgoingMessageTableViewCell.self)
        messagesTableView.registerReusableCell(IncomingMessageTableViewCell.self)
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 100
        messagesTableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        viewModel.newIncomingMessageListerner = { [unowned self] in
            self.messagesTableView.reloadData()
            self.messagesTableView.scrollToBottom()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetching messages from local database is performed here because this fetch doesn't require waiting for async operation. So if this fetch is done from the viewDidLoad there is a UI flickering for scroll to bottom operation of UITableView.
        viewModel.fetchMessages { [unowned self] in
            self.activityIndicatorView.stopAnimating()
            self.messagesTableView.reloadData()
            self.messagesTableView.scrollToBottom()
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    deinit {
        shouldStopHandlingViewForKeyboardAppearance()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if let messageText = messageInputTextView.text, !messageText.isEmpty {
            messageInputTextView.text = ""
            viewModel.send(text: messageText) { [unowned self] _ in
                self.messagesTableView.reloadData()
                self.messagesTableView.scrollToBottom()
            }
        }
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        // In conjunction with the implementation of super class, some adjustment is needed on the table view for good UX.
        guard messagesTableViewTopConstraint.constant == 0,
            let userInfo = notification.userInfo,
            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            else { return }

        guard !isEnoughContentAvailableOnTableView(for: keyboardHeight) else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.messagesTableViewTopConstraint.constant += keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        // In conjunction with the implementation of super class, some adjustment is needed on the table view for good UX.
        guard messagesTableViewTopConstraint.constant != 0,
            let userInfo = notification.userInfo,
            let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height // Though the height isn't used here, calculation is made to be sure that the event is from keyboard hiding notification.
            else { return }

        UIView.animate(withDuration: 0.5) {
            self.messagesTableViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    /// Determines whether there is enough content available in the table view so that pushing it out of screen doesn't hide every content.
    ///
    /// - Parameter keyboardHeight: The height of the keyboard.
    /// - Returns: A Boolean value indicating whether enough content is available or not.
    private func isEnoughContentAvailableOnTableView(for keyboardHeight: CGFloat) -> Bool {
        let totalHeight = messagesTableView.contentSize.height + keyboardHeight
        return totalHeight > messagesTableView.bounds.height + messageInputBoxHeightConstraint.constant
    }
    
}

extension MessagingViewController: StoryboardInstantiable {

    static var storyboardName: StoryboardName {
        return .messaging
    }
    
}

extension MessagingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = viewModel.messages[indexPath.row]
        switch message.type {
        case .incoming:
            let cell = IncomingMessageTableViewCell.dequeue(fromTableView: tableView, atIndex: indexPath)
            cell.viewModel = IncomingMessageTableViewCellViewModel(message: message)
            return cell
        case .outgoing:
            let cell = OutgoingMessageTableViewCell.dequeue(fromTableView: tableView, atIndex: indexPath)
            cell.viewModel = OutgoingMessageTableViewCellViewModel(message: message)
            return cell
        }

    }

}
