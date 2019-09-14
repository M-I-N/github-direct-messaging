//
//  MessagingCoordinator.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class MessagingCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let user: User

    init(presenter: UINavigationController, user: User) {
        self.presenter = presenter
        self.user = user
    }

    func start() {
        let messagingViewController = MessagingViewController.instantiateFromStoryboard()
        messagingViewController.viewModel = MessagingViewModel(user: user, client: GitHubClient())
        presenter.pushViewController(messagingViewController, animated: true)
    }

}
