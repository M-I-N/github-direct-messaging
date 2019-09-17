//
//  FollowerListViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation
import CoreData

class FollowerListViewModel: NSObject {
    
    let title = "GitHub DM"

    /// Closure to be called when new followers are fetched and synced with the storage.
    var onAvailabilityOfNewFollowers: (() -> Void)?
    var onErrorHandling: ((String, String) -> Void)?
    
    private let client: GitHubClient
    private let persistentContainer = CoreDataManager.shared.persistentContainer

    private lazy var fetchedResultsController: NSFetchedResultsController<UserData> = {
        let entityName = String(describing: UserData.self)
        let fetchRequest = NSFetchRequest<UserData>(entityName: entityName)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true) ]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self

        do {
            try controller.performFetch()
        } catch {
            print(error)
        }

        return controller
    }()
    
    /// Initializer with network client.
    ///
    /// - Parameter client: A client object capable of performing network operations.
    init(client: GitHubClient) {
        self.client = client
    }
    
    /// Fetches followers from the network.
    ///
    /// This method asynchronously fetches followers from the network and sync them with the storage option. To be informed about new fetched followers use `onAvailabilityOfNewFollowers` closure.
    ///
    /// - Remark: Look at `onAvailabilityOfNewFollowers: (() -> Void)?` also
    func fetchFollowers() {
        client.getUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                UserStorage.shared.sync(users: users, with: self.persistentContainer)
            case .failure(let error):
                switch error {
                case .standard(let apiError):
                    print(apiError.customDescription)
                case .limitExceeded(let rateLimit):
                    self.handleRateLimitError(rateLimit: rateLimit)
                }
            }
        }
    }

    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfFollowers(in section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func follower(at indexPath: IndexPath) -> User {
        let userData = fetchedResultsController.object(at: indexPath)
        let user = User(userData: userData)!
        return user
    }

    func selectedFollower(at indexPath: IndexPath) -> User {
        return follower(at: indexPath)
    }

}

extension FollowerListViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // new data available
        onAvailabilityOfNewFollowers?()
    }
}

extension FollowerListViewModel: RateLimitReporting {

    func handleError(title: String, message: String) {
        onErrorHandling?(title, message)
    }

    func handleRateLimitError(rateLimit: GitHubClientError.RateLimit) {
        guard let timeDifference = Date().howLongUntil(dateInFuture: rateLimit.resetDate) else { return }
        let title = "Can't fetch followers at this moment."
        let message = "Please try again after \(timeDifference). If you still don't see your followers please contact with the support team."
        handleError(title: title, message: message)
    }

}
