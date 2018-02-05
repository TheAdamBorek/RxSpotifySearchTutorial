//
// Created by Adam Borek on 05.02.2018.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Moya
import Foundation
protocol SpotifyAPIRequest: APIRequest { }
extension SpotifyAPIRequest {
    var baseURL: URL {
        return  Assembly.configuration.spotifyAPIBaseURL
    }
}

struct SearchRequest: SpotifyAPIRequest {
    let query: String

    init(query: String) {
        self.query = query
    }

    let path = "v1/search"
    let method: Moya.Method = .get
    var params: [String: Any] {
        return [
            "q":query,
            "type":"track",
            "market":"US"
        ]
    }
    var paramsEncoder: ParameterEncoding {
        return URLEncoding()
    }
}
