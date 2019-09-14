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
        // FIXME: dummy messages data used for now. In real app, this array of messages will be provided as a parameter to the initializer itself.
        messages = [ Message(text: "Hello!", sender: .current),
                     Message(text: "Hello! Hello!", sender: user),
                     Message(text: "The quick brown fox jumped over the lazy dog.", sender: .current),
                     Message(text: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. ", sender: user) ]
    }
    
    func send(message: Message, completion: @escaping (Bool) -> Void) {
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

