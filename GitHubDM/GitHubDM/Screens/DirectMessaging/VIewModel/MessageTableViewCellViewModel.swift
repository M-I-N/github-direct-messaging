//
//  MessageTableViewCellViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/13/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct OutgoingMessageTableViewCellViewModel {
    let messageBody: String
}

extension OutgoingMessageTableViewCellViewModel {
    init(message: Message) {
        self.messageBody = message.text
    }
}

struct IncomingMessageTableViewCellViewModel {
    let messageBody: String
}

extension IncomingMessageTableViewCellViewModel {
    init(message: Message) {
        self.messageBody = message.text
    }
}
