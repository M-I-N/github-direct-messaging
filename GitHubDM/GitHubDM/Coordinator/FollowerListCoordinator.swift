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
    private var messagingCoordinator: MessagingCoordinator?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let viewModel = FollowerListViewModel(client: GitHubClient())
        let followerListViewController = FollowerListViewController(viewModel: viewModel)
        followerListViewController.delegate = self
        presenter.pushViewController(followerListViewController, animated: true)
    }

}

extension FollowerListCoordinator: FollowerListViewControllerDelegate {
    func followerListViewController(_ controller: FollowerListViewController, didSelect follower: User) {
        let messagingCoordinator = MessagingCoordinator(presenter: presenter, user: follower)
        self.messagingCoordinator = messagingCoordinator
        self.messagingCoordinator?.start()
    }
}
