//
//  MessagingViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class MessagingViewModel {
    let title: String
    let user: User
    private (set) var messages = [Message]()
    var newIncomingMessageListerner: (() -> Void)?
    
    private let client: GitHubClient

    var titleFormattedAsGitHubHandle: String {
        return title.withMentioninPrefix
    }
    
    init(user: User, client: GitHubClient) {
        title = user.login
        self.user = user
        self.client = client
        // load messages from local database
    }
    
    func send(text: String, completion: @escaping (Bool) -> Void) {
        let message = Message(text: text, sender: User.current)
        messages.append(message)
        client.post(message: message, to: user, completion: completion)
        
        // As every sent message to any will be echoed back to sender, implement a dummy echo by repeating the text of the sent message twice
        // In real app, this code doesn't belong here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let text = Array(repeating: message.text, count: 2).joined(separator: " ")
            let newMessage = Message(text: text, sender: self.user)
            self.messages.append(newMessage)
            self.newIncomingMessageListerner?()
        }
    }
    
}

