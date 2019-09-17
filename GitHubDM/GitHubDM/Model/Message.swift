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
    let receiver: User
    let creationDate: Date

    var type: Type {
        return sender == .current ? .outgoing : .incoming
    }

    enum `Type` {
        case incoming
        case outgoing
    }

}

extension Message {
    
    init?(messageData: MessageData) {
        
        guard let text = messageData.text,
            let senderData = messageData.sender,
            let receiverData = messageData.receiver,
            let creationDate = messageData.creationDate
            else { return nil }
        
        do {
            self.sender = try JSONDecoder().decode(User.self, from: senderData)
            self.receiver = try JSONDecoder().decode(User.self, from: receiverData)
        } catch {
            print(error)
            return nil
        }
        
        self.text = text
        self.creationDate = creationDate
        
    }
    
    func convertTo(messageData: MessageData) throws {
        messageData.text = text
        messageData.creationDate = creationDate
        messageData.sender = try JSONEncoder().encode(sender)
        messageData.receiver = try JSONEncoder().encode(receiver)
    }
    
}
