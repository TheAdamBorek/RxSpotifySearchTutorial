//
//  Rx+filterNil.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 06.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

protocol OptionalType {
    associatedtype WrappedValue

    var value: WrappedValue? { get }
}

extension Optional: OptionalType {
    typealias WrappedValue = Wrapped

    var value: Wrapped? {
        switch self {
        case .some(let value):
            return value
        case .none:
            return nil
        }
    }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.WrappedValue> {
        return flatMap { (optional: Self.E) -> Observable<E.WrappedValue>  in
            if let value = optional.value {
                return .just(value)
            } else {
                return .never()
            }
        }
    }
}
