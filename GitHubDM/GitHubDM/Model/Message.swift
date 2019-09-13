//
//  Message.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/13/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct Message {
    let text: String
    let sender: User

    var type: Type {
        return sender == .current ? .outgoing : .incoming
    }

    enum `Type` {
        case incoming
        case outgoing
    }

}
