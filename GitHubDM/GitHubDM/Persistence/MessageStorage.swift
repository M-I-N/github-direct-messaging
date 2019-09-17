//
//  MessageStorage.swift
//  GitHubDM
//
//  Created by Nayem on 9/15/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class MessageStorage {
    
    static let shared = MessageStorage()
    
    private init() { }
    
    func store(message: Message, completion: (Result<Void, CoreDataError>) -> Void) {
        do {
            let messageData: MessageData = CoreDataManager.shared.initManagedObject()
            try message.convertTo(messageData: messageData)
            CoreDataManager.shared.saveContext()
            completion(.success(()))
        } catch {
            completion(.failure(.insertionFailure(error: error)))
        }
    }
    
    func fetchAllMessages(between user1: User, and user2: User, inAscendingCreationDate: Bool = true, completion: (Result<[Message], CoreDataError>) -> Void) {
        do {
            
            let encodedUser1 = try JSONEncoder().encode(user1)
            let encodedUser2 = try JSONEncoder().encode(user2)
            
            let outgoingSenderPredicate = NSPredicate(format: "sender == %@", encodedUser1 as CVarArg)
            let outgoingReceiverPredicate = NSPredicate(format: "receiver == %@", encodedUser2 as CVarArg)
            let outgoingMessageFilterPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [outgoingSenderPredicate, outgoingReceiverPredicate])
            
            let incomingSenderPredicate = NSPredicate(format: "sender == %@", encodedUser2 as CVarArg)
            let incomingReceiverPredicate = NSPredicate(format: "receiver == %@", encodedUser1 as CVarArg)
            let incomingMessageFilterPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [incomingSenderPredicate, incomingReceiverPredicate])
            
            let filterPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [outgoingMessageFilterPredicate, incomingMessageFilterPredicate])
            
            let sortDescriptor = inAscendingCreationDate ? [NSSortDescriptor(key: "creationDate", ascending: inAscendingCreationDate)] : nil
            let messageDatas: [MessageData] = CoreDataManager.shared.fecth(withFilter: filterPredicate, sorting: sortDescriptor)
            let messages = messageDatas.compactMap { Message(messageData: $0) }
            completion(.success(messages))
        } catch {
            completion(.failure(.fetchingFailure(error: error)))
        }
    }
}
