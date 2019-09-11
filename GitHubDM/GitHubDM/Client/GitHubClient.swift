//
//  GitHubClient.swift
//  GitHubDM
//
//  Created by Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

class GitHubClient: GenericAPIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    
    /// Get the users from UsersEndpoint. The completion is guaranteed to be performed on the main queue.
    ///
    /// - Parameter completion: A closure that will be executed after fetch operation.
    func getUsers(completion: @escaping (Result<[User], APIError>) -> Void) {
        let endpoint = UsersEndpoint()
        fetch(with: endpoint.request, decoder: JSONDecoder(), completion: completion)
    }
    
}

struct UsersEndpoint: Endpoint {
    
    let base = "https://api.github.com"
    let path = "/users"
    let queryItems: [URLQueryItem]? = nil
    
}
