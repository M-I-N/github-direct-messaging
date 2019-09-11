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
                print(error)
            }
            completion()
        }
    }
    
}
