//
//  UIViewController+NavigationBar.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/13/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Removes the title in the back button of the navigation bar item. Just invoke this func from the previous view controller of the target view controller (in which screen, the back button title should not be shown)
    func removeNavigationBarBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
