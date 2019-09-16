//
//  FollowerListViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class FollowerListViewModel {
    
    let title = "GitHub DM"
    private (set) var followers = [User]()
    var onErrorHandling: ((String, String) -> Void)?
    
    private var client: GitHubClient? = nil
    
    
    /// Initializes the object with provided model object.
    ///
    /// - Parameter followers: An array of User obejects.
    init(followers: [User]) {
        self.followers = followers
    }
    
    /// Initializer with network client. Use this initializer when follower list needs to be fetched over the network.
    ///
    /// - Parameter client: A client object capable of performing network operations.
    init(client: GitHubClient) {
        self.client = client
    }
    
    /// Fetches followers from the network if the client based initializer is used at the time of object creation. Otherwise calls completion immediately.
    ///
    /// - Parameter completion: A closure that will be executed when fetch completes.
    func fetchFollowers(completion: @escaping () -> Void) {
        guard let client = client else { completion(); return }
        client.getUsers { [weak self] result in
            guard let self = self else { completion(); return }
            switch result {
            case .success(let users):
                self.followers = users
            case .failure(let error):
                switch error {
                case .standard(let apiError):
                    print(apiError.customDescription)
                case .limitExceeded(let rateLimit):
                    self.handleRateLimitError(rateLimit: rateLimit)
                }
            }
            completion()
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
