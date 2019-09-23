//
//  FollowerListViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation
import CoreData

struct FollowerListViewModel {
    
    let title = "GitHub DM"

    let dataSource = FollowerlistTableViewDataSource(persistentContainer: CoreDataManager.shared.persistentContainer) { (user, cell) in
        cell.viewModel = FollowerTableViewCellViewModel(follower: user)
    }
    var onErrorHandling: ((String, String) -> Void)?
    
    private let client: GitHubClient
    
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
        client.getUsers { result in
            switch result {
            case .success(let users):
                UserStorage.shared.sync(users: users, with: self.dataSource.persistentContainer)
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
