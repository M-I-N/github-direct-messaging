//
//  MessagingViewController.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/11/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController {

    @IBOutlet private weak var messageInputTextView: UITextView!
    
    var viewModel: MessagingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
        messageInputTextView.layer.cornerRadius = 20
        shouldStartHandlingViewForKeyboardAppearnce()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    deinit {
        shouldStopHandlingViewForKeyboardAppearance()
    }

}

extension MessagingViewController: StoryboardInstantiable {

    static var storyboardName: StoryboardName {
        return .messaging
    }
    
}
