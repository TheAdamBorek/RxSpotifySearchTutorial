//
// Created by Adam Borek on 05.02.2018.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation

struct Configuration {
    enum Error: Swift.Error {
        case cannotFetchBaseURL
    }

    let spotifyAPIBaseURL: URL
    let spotifyAccountsBaseURL: URL

    init() throws {
        guard let spotifyAPIBaseURL = URL(string: "https://api.spotify.com"),
            let spotifyAccountsBaseURL = URL(string: "https://accounts.spotify.com") else {
                throw Error.cannotFetchBaseURL
        }
        self.spotifyAccountsBaseURL = spotifyAccountsBaseURL
        self.spotifyAPIBaseURL = spotifyAPIBaseURL
    }
}
