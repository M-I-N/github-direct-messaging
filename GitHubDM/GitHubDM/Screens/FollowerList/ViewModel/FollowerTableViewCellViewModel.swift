//
//  FollowerTableViewCellViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct FollowerTableViewCellViewModel {
    let name: String
    let imageURL: URL

    var formattedAsGitHubHandle: String {
        return name.withMentioninPrefix
    }
}

extension FollowerTableViewCellViewModel {
    init(follower: User) {
        name = follower.login
        imageURL = follower.avatarURL
    }
}
