//
//  ApplicationCoordinator.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        let followerListCoordinator = FollowerListCoordinator(presenter: rootViewController)
        window.rootViewController = rootViewController
        followerListCoordinator.start()
        window.makeKeyAndVisible()
    }

}
