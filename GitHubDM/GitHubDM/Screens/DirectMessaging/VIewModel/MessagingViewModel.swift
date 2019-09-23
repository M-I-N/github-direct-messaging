//
//  MessagingViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class MessagingViewModel {

    private (set) var messages = [Message]()
    var newIncomingMessageListerner: (() -> Void)?
    
    private let client: GitHubClient
    private let title: String
    private let user: User

    var titleFormattedAsGitHubHandle: String {
        return title.withMentioninPrefix
    }
    
    init(user: User, client: GitHubClient) {
        title = user.login
        self.user = user
        self.client = client
    }
    
    func send(text: String, completion: @escaping (Bool) -> Void) {
        let message = Message(text: text, sender: User.current, receiver: self.user, creationDate: Date())
        MessageStorage.shared.store(message: message) { result in
            switch result {
            case .success(_):
                messages.append(message)
            case .failure(let error):
                print(error.customDescription)
            }
        }
        
        client.post(message: message, to: user, completion: completion)
        
        // As every sent message to any will be echoed back to sender, implement a dummy echo by repeating the text of the sent message twice
        // In real app, this code doesn't belong here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let text = Array(repeating: message.text, count: 2).joined(separator: " ")
            let newMessage = Message(text: text, sender: self.user, receiver: User.current, creationDate: Date())
            MessageStorage.shared.store(message: newMessage, completion: { result in
                switch result {
                case .success(_):
                    self.messages.append(newMessage)
                    self.newIncomingMessageListerner?()
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func fetchMessages(completion: () -> Void) {
        MessageStorage.shared.fetchAllMessages(between: User.current, and: user, inAscendingCreationDate: true) { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                print(error.customDescription)
            }
            completion()
        }
    }
    
}

