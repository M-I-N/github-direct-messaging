//
//  MessagingViewController.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController {

    var viewModel: MessagingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
    }

}

extension MessagingViewController: StoryboardInstantiable {

    static var storyboardName: StoryboardName {
        return .messaging
    }
    
}
