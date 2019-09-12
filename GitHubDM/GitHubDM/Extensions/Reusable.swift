//
//  Reusable.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

/// Provides everything necessary for a view to get associated UINib.
internal protocol NibInitable: class {

    /// UINib containing the Interface Builder representation.
    static var nib: UINib? { get }

}

internal extension NibInitable {

    /// Uses the UINib named after the object's type name.
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }

}

/// Represents a UIView that is a reuseable view such as a
/// UITableViewCell, UITableViewHeaderFooterView or UITableViewCell.
/// Provides everything necessary for a reusable view to be reused.
internal protocol Reusable: NibInitable {

    /// Identifier used to dequeue this view for reuse.
    static var reuseIdentifier: String { get }

}

/// Provides default implementations of the necessary variables
/// to reuse a generic view.
internal extension Reusable {

    /// Uses the object's Type name as the ReuseIdentifier.
    static var reuseIdentifier: String { return String(describing: self) }

}

/// Declares that all UITableViewCell conform to the
/// Reusable protocol and therefore gain the default
/// implementation without any additional effort.
extension UITableViewCell: Reusable { }
