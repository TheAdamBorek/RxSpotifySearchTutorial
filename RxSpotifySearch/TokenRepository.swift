//
//  TokenRepository.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 06.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

enum TokenReadingError: Swift.Error {
    case tokenIsNotStored
    case cannotFetchTokenFromRemote
}

protocol TokenReader {
    func getToken() -> Observable<String>
}

protocol TokenWriter {
    func save(token: String)
    func refreshToken() -> Observable<String>
}

final class TokenRepository: TokenReader, TokenWriter {
    private var storage: TokenStoring
    private let api: APIClient

    init(storage: TokenStoring = UserDefaultsTokenStorageAdapter(),
         api: APIClient = APIClient()) {
        self.storage = storage
        self.api = api
    }

    func getToken() -> Observable<String> {
        return Observable.deferred {
            if let token = self.storage.token {
                return .just(token)
            } else {
                return self.refreshToken()
            }
        }
    }

    func save(token: String) {
        storage.token = token
    }

    func refreshToken() -> Observable<String> {
        return fetchToken
            .do(onNext: save,
                onError: { _ in
                self.storage.token = nil
            })
    }

    lazy var fetchToken: Observable<String> = {
        return self.api.request(FetchTokenRequest())
            .map { (data: Data) -> String in
                let json = try JSON(data: data)
                guard let accessToken = json["access_token"].string else {
                    throw TokenReadingError.cannotFetchTokenFromRemote
                }
                return accessToken
            }
            .share(scope: .whileConnected)
    }()
}
