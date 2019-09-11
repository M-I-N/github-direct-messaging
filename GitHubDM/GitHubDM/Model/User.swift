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
    
}
