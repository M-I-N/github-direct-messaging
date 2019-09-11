//
//  User.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarURL: URL

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }

    static var dummyUsers: [User] {
        let users = [ User(login: "JustinaMeindl", avatarURL: URL(string: "https://github.com/images/error/octocat_happy.gif")!),
                      User(login: "StephaneWilkerson", avatarURL: URL(string: "https://github.com/images/error/octocat_happy.gif")!),
                      User(login: "MikaSpurling", avatarURL: URL(string: "https://github.com/images/error/octocat_happy.gif")!),
                      User(login: "DavisClinton", avatarURL: URL(string: "https://github.com/images/error/octocat_happy.gif")!),
                      User(login: "ValerieAgosti", avatarURL: URL(string: "https://github.com/images/error/octocat_happy.gif")!) ]
        return users
    }
}
