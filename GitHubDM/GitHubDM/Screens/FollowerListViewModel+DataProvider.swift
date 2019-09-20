//
//  FollowerListViewModel+DataProvider.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/20/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit
import CoreData

class FollowerlistTableViewDataSource: TableViewDataSource<User, FollowerTableViewCell> {

    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer,
         model type: User.Type, cell cellType: FollowerTableViewCell.Type,
         reuseIdentifier: String = String(describing: FollowerTableViewCell.self),
         cellConfiguration: @escaping CellConfigurator) {
        self.persistentContainer = persistentContainer
        super.init(model: type, cell: cellType, reuseIdentifier: reuseIdentifier, cellConfiguration: cellConfiguration)
    }

    convenience init(persistentContainer: NSPersistentContainer, cellConfiguration: @escaping CellConfigurator) {
        self.init(persistentContainer: persistentContainer, model: User.self, cell: FollowerTableViewCell.self, reuseIdentifier: String(describing: FollowerTableViewCell.self), cellConfiguration: cellConfiguration)
    }

    private lazy var fetchedResultsController: NSFetchedResultsController<UserData> = {
        let entityName = String(describing: UserData.self)
        let fetchRequest = NSFetchRequest<UserData>(entityName: entityName)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self

        do {
            try controller.performFetch()
        } catch {
            print(error)
        }

        return controller
    }()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowerTableViewCell
        let userData = fetchedResultsController.object(at: indexPath)
        if let model = User(userData: userData) {
            cellConfigurator(model, cell)
        }
        return cell
    }
    
}

extension FollowerlistTableViewDataSource: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let userDataController = controller as? NSFetchedResultsController<UserData> else { return }
        if let users = userDataController.fetchedObjects?.compactMap({ User(userData: $0) }) {
            data.value = users
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let userDataController = controller as? NSFetchedResultsController<UserData> else { return }
        if let users = userDataController.fetchedObjects?.compactMap({ User(userData: $0) }) {
            data.value = users
        }
    }

}
