//
//  ErrorReporting.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/16/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

protocol ErrorReporting {
    func handleError(title: String, message: String)
}

protocol RateLimitReporting: ErrorReporting {
    func handleRateLimitError(rateLimit: GitHubClientError.RateLimit)
}
