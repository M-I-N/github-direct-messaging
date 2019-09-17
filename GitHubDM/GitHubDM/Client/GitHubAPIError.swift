//
//  GitHubAPIError.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/16/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

enum GitHubClientError: Error {
    case standard(apiError: APIError)
    case limitExceeded(rateLimit: RateLimit)

    struct RateLimit: Decodable {
        let remaining: String
        let reset: String

        private enum CodingKeys: String, CodingKey {
            case remaining = "X-RateLimit-Remaining"
            case reset = "X-RateLimit-Reset"
        }

        var remainingLimit: Int {
            return Int(remaining)!
        }

        var resetDate: Date {
            let timeInterval = TimeInterval(reset)!
            return Date(timeIntervalSince1970: timeInterval)
        }
    }
}
