//
// Created by Adam Borek on 05.02.2018.
// Copyright (c) 2018 Adam Borek. All rights reserved.
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
}

struct Configuration {
    let spotifyAPIBaseURL: URL

    init() throws {
        self.spotifyAPIBaseURL = URL(string: "https://api.spotify.com")!
    }
}
