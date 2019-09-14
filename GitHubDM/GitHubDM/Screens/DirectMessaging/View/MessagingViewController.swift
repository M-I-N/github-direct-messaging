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
    
    var viewModel: MessagingViewModel!

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
        
        viewModel.newIncomingMessageListerner = { [unowned self] in
            self.messagesTableView.reloadData()
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
            let message = Message(text: messageText, sender: User.current)
            viewModel.send(message: message) { [unowned self] _ in
                self.messagesTableView.reloadData()
            }
        }
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
