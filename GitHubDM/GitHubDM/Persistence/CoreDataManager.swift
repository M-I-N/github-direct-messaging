//
//  CoreDataManager.swift
//  GitHubDM
//
//  Created by Nayem on 9/15/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitHubDM")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func initManagedObject<T: NSManagedObject>() -> T {
        let managedObj = T(context: persistentContainer.viewContext)
        return managedObj
    }

    func initManagedObject<T: NSManagedObject>(for context: NSManagedObjectContext) -> T {
        let managedObject = T(context: context)
        return managedObject
    }
    
    func fecth<T: NSManagedObject>(withFilter predicates: NSCompoundPredicate? = nil, sorting sorters: [NSSortDescriptor]? = nil) -> [T] {
        let context = persistentContainer.viewContext
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicates
        request.sortDescriptors = sorters
        do {
            let records = try context.fetch(request)
            return records
        } catch {
            print(error)
            return []
        }
    }
    
}
