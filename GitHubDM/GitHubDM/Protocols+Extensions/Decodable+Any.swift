//
//  Decodable+Any.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/16/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

extension Decodable {

    init(from value: Any, options: JSONSerialization.WritingOptions = [], decoder: JSONDecoder) throws {
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        self = try decoder.decode(Self.self, from: data)
    }

    init(from value: Any, options: JSONSerialization.WritingOptions = [], decoderSetupClosure: ((JSONDecoder) -> Void)? = nil) throws {
        let decoder = JSONDecoder()
        decoderSetupClosure?(decoder)
        try self.init(from: value, options: options, decoder: decoder)
    }

}
