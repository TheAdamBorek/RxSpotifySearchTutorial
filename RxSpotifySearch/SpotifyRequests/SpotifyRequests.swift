//
// Created by Adam Borek on 05.02.2018.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Moya
import Foundation
import CryptoSwift

protocol SpotifyAPIRequest: APIRequest { }
extension SpotifyAPIRequest {
    var baseURL: URL {
        return  Assembly.configuration.spotifyAPIBaseURL
    }
}

protocol SpotifyAccountsRequest: APIRequest { }
extension SpotifyAccountsRequest {
    var baseURL: URL {
        return  Assembly.configuration.spotifyAccountsBaseURL
    }
}

extension APIRequest {
    func authorized(with token: String) -> APIRequest {
        return AuthorizedRequest(base: self, token: token)
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

struct FetchTokenRequest: SpotifyAccountsRequest {
    private let clientID = "73a5a85861f4461596a2188778763604"
    private let clientSecret = "4f3709e1b14c490eaa81cb6c4b7c72f7"
    let path: String = "/api/token"
    let method: Moya.Method = .post

    var params: [String: Any] {
        return ["grant_type":"client_credentials"]
    }

    var headers: [String : String]? {
        let authorizationValue = "\(clientID):\(clientSecret)".bytes.toBase64() ?? ""
        assert(!authorizationValue.isEmpty)
        return ["Authorization":"Basic \(authorizationValue)"]
    }

    var paramsEncoder: ParameterEncoding {
        return URLEncoding()
    }
}

struct AuthorizedRequest: APIRequest {
    private let base: APIRequest
    private let token: String

    init(base: APIRequest, token: String) {
        self.base = base
        self.token = token
    }

    var baseURL: URL { return base.baseURL  }
    var path: String { return base.path }
    var method: Moya.Method { return base.method }
    var params: [String: Any] { return base.params }
    var paramsEncoder: ParameterEncoding { return base.paramsEncoder }

    var headers: [String: String]? {
        var headers = base.headers ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}
