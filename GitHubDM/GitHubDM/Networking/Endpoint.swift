//
//  Endpoint.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

protocol Endpoint {

    /// The base URL of the resource as String. Don't return any path component after the domain name. Ex. https://baseurl.com
    var base: String { get }

    /// Path of the Endpoint. Ex. /resource/path
    var path: String { get }


    /// Array of name-value pair to be used for the query portion of the final Endpoint.
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {

    private var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base) else { return nil }
        components.path = path
        components.queryItems = queryItems
        return components
    }

    var request: URLRequest {
        let url = urlComponents?.url ?? URL(string: "\(base)\(path)")!
        let request = URLRequest(url: url)
        return request
    }

}
