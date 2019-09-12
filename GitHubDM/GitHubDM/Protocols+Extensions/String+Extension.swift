//
//  String+Extension.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/12/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

extension String {

    /// Adds the '@' character at the beginning
    var withMentioninPrefix: String {
        return "@" + self
    }
    
}
