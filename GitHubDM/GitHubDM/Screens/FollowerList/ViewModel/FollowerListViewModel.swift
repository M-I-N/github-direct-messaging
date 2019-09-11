//
//  FollowerListViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct FollowerListViewModel {
    let title = "GitHub DM"
    let followers: [User]
}

extension FollowerListViewModel {
    init(user: [User]) {
        followers = user
    }
}
