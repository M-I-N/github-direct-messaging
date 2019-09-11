//
//  MessagingViewModel.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct MessagingViewModel {
    let title: String
}

extension MessagingViewModel {
    init(user: User) {
        title = user.login
    }
}
