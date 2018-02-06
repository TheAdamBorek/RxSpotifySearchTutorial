//
//  Assembly.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 07.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
enum Assembly {
    static let configuration: Configuration = {
        do {
            return try Configuration()
        } catch let e {
            fatalError("Error during reading the configuration: \(e)")
        }
    }()

    static let tokenRepository = TokenRepository()
}
