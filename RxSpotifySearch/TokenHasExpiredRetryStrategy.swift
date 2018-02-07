//
//  TokenHasExpiredRetryStrategy.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 07.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol RetryStrategy {
    func retryTrigger(errorHandler: Observable<Swift.Error>) -> Observable<Void>
}

struct TokenHasExpiredRetryStrategy: RetryStrategy {
    private let tokenWriter: TokenWriter

    init(tokenWriter: TokenWriter = Assembly.tokenRepository) {
        self.tokenWriter = tokenWriter
    }

    func retryTrigger(errorHandler: Observable<Swift.Error>) -> Observable<Void> {
        return tryToRetry(numberOfTimes: 1, errorStream: errorHandler) { (error: Swift.Error) -> Observable<Void> in
            if self.isUnauthorizedError(error) {
                return self.refreshTokenAndRetry()
            } else {
                return self.denyRetry(byThrowing: error)
            }
        }
    }

    private func tryToRetry(numberOfTimes attempts: Int, errorStream: Observable<Swift.Error>, retryClosure: @escaping (Swift.Error) -> Observable<Void>) -> Observable<Void> {
        let rangeObservableToLimitNumberOfRetries = Observable.range(start: 0, count: attempts)
        return Observable
            .zip(rangeObservableToLimitNumberOfRetries, errorStream) { $1 }
            .flatMap(retryClosure)
            .concat(forwardNextErrorsToMainStream(errorStream))
    }

    private func forwardNextErrorsToMainStream(_ errors: Observable<Swift.Error>) -> Observable<Void> {
        return errors.flatMap { error in return Observable<Void>.error(error) }
    }

    private func isUnauthorizedError(_ error: Error) -> Bool {
        switch error {
        case MoyaError.statusCode(let response):
            return response.statusCode == 401
        default:
            return false
        }
    }

    private func refreshTokenAndRetry() -> Observable<Void> {
        return tokenWriter.refreshToken().map { _ in return () }
    }

    private func denyRetry(byThrowing error: Swift.Error) -> Observable<Void> {
        return Observable<Void>.error(error)
    }
}
