//
//  TrackProvider.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 05.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol TracksProviding {
    func tracks(for query: String) -> Observable<[Track]>
}

final class TracksProvider: TracksProviding {
    enum Error: Swift.Error {
        case invalidJSON
    }

    private let api: APIClient
    private let tokenRepository: TokenRepository
    private let retryStrategy: RetryStrategy

    init(api: APIClient = APIClient(),
         tokenRepository: TokenRepository = Assembly.tokenRepository,
         retryStrategy: RetryStrategy = TokenHasExpiredRetryStrategy()) {
        self.api = api
        self.tokenRepository = tokenRepository
        self.retryStrategy = retryStrategy
    }

    func tracks(for query: String) -> Observable<[Track]> {
        return self.tokenRepository.getToken()
            .map { self.prepareSearchRequest(for: query, authorizedWith: $0) }
            .flatMap(api.request)
            .map(parseTracks)
            .retryWhen(retryStrategy.retryTrigger)
    }

    private func prepareSearchRequest(for query: String, authorizedWith token: String) -> APIRequest {
        return SearchRequest(query: query)
            .authorized(with: token)
    }

    private func parseTracks(from data: Data) throws -> [Track] {
        let json = try JSON(data: data)
        guard let tracksJSON = json["tracks"]["items"].array else {
            throw Error.invalidJSON
        }
        return tracksJSON.flatMap(Track.init)
    }
}
