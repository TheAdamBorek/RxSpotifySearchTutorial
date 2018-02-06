//
//  TokenStorage.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 06.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation

protocol TokenStoring {
    var token: String? { get set }
}

final class UserDefaultsTokenStorageAdapter: TokenStoring {
    private let clientTokenKey = "spotifySearch.clientToken"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var token: String? {
        get {
            return userDefaults.string(forKey: clientTokenKey)
        }

        set {
            userDefaults.set(newValue, forKey: clientTokenKey)
        }
    }
}
