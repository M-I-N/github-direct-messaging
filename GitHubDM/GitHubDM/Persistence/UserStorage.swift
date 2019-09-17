//
//  UserStorage.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/17/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import CoreData

class UserStorage {

    static let shared = UserStorage()

    private init() { }

    func sync(users: [User], with container: NSPersistentContainer) {
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        taskContext.performAndWait {
            let entityName = String(describing: UserData.self)
            let userDataRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let uniqueIDs = users.map { $0.id }
            userDataRequest.predicate = NSPredicate(format: "id in %@", uniqueIDs)

            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: userDataRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            // Execute the request to batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult

                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs], into: [container.viewContext])
                }
            } catch {
                print(error)
            }

            // Create new records.
            users.forEach { user in
                let userData: UserData = CoreDataManager.shared.initManagedObject(for: taskContext)
                user.convertTo(userData: userData)
            }

            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print(error)
                }
                // Reset the context to clean up the cache and low the memory footprint.
                taskContext.reset()
            }
        }
    }

}
