//
//  MessagingViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct MessagingViewModel {
    let title: String
    let user: User
    let messages: [Message]

    var titleFormattedAsGitHubHandle: String {
        return title.withMentioninPrefix
    }
}

extension MessagingViewModel {
    init(user: User) {
        title = user.login
        self.user = user
        // FIXME: dummy messages data used for now. In real app, this array of messages will be provided as a parameter to the initializer itself.
        messages = [ Message(text: "Hello!", sender: .current),
                     Message(text: "Hello! Hello!", sender: user),
                     Message(text: "The quick brown fox jumped over the lazy dog.", sender: .current),
                     Message(text: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. ", sender: user) ]
    }
}
