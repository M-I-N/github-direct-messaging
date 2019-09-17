//
//  User.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let login: String
    let id: Int
    let avatarURL: URL

    // FIXME: Just used for dummy purpose as any message item needs an user object. And for distinguishing between sender & reciever of the message, a current user is needed. But in real app this should be fetched from authentication module.
    static let current = User(login: "Nayem", id: Int.min, avatarURL: URL(string: "https://avatars0.githubusercontent.com/u/1?v=4")!)

    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
    }
    
}

extension User {

    init?(userData: UserData) {
        guard let login = userData.login,
            let avatarURL = userData.avatarURL
            else { return nil }

        self.login = login
        self.id = Int(userData.id)
        self.avatarURL = avatarURL
    }

    func convertTo(userData: UserData) {
        userData.login = login
        userData.id = Int32(id)
        userData.avatarURL = avatarURL
    }

}
