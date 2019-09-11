//
//  FollowerListCoordinator.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class FollowerListCoordinator: Coordinator {

    private let presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let viewModel = FollowerListViewModel(followers: User.dummyUsers)
        let followerListViewController = FollowersListViewController(viewModel: viewModel)
        presenter.pushViewController(followerListViewController, animated: true)
    }

}
