//
//  UITableView+Reusable.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

/// Provides default implementations of generic reuse methods on UITableView to
/// allow for consumers to register reuseable views for reuse such as UITableViewCells.
internal extension UITableView {

    /// Registers a UITableViewCell subclass for reuse, by
    /// registering a UINib or Type for the object's reuseIdentifier.
    ///
    /// - Parameter _: UITableViewCell to register for reuse.
    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    /// Dequeues a UITableViewCell for reuse given a specific indexPath.
    ///
    /// - Parameter indexPath: indexPath to dequeue cell for
    /// - Returns: a reused UITableViewCell associated with the indexPath
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

}
