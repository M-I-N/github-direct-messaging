//
//  CoreDataError.swift
//  GitHubDM
//
//  Created by Nayem on 9/15/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

enum CoreDataError: Error {
    
    case insertionFailure(error: Error)
    case fetchingFailure(error: Error)
    
    var customDescription: String {
        switch self {
        case .insertionFailure(let error) : return "CoreDataError - Data encoding Failure -> \(error)"
        case .fetchingFailure(let error) : return "CoreDataError - Data decoding Failure -> \(error)"
        }
    }
    
}
