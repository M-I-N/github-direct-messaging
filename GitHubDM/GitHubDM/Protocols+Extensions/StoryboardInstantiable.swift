//
//  StoryboardInstantiable.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: class {

    /// Adds the ability for conforming class to have an associated Storyboard name.
    ///
    /**
     - SeeAlso:
     `StoryboardName` for available names.
     */
    static var storyboardName: StoryboardName { get }

    /// Adds the ability for conforming class that can be instantiated from Storyboard given that the Storyboard ID is same as the class name.
    ///
    /// Default implementation available.
    /// - Returns: A fully initialized class from Storyboard.
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiable {

    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

}

// MARK: -

/// The names of the storyboard files. Add new cases when required.
enum StoryboardName: String {
    case main = "Main"
    case messaging = "Messaging"
}
