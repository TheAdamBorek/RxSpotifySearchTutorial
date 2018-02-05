//
//  TrackProvider.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 05.02.2018.
//  Copyright © 2018 Adam Borek. All rights reserved.
//

import Foundation
import RxSwift

protocol TracksProviding {
    func tracks(for query: String) -> Single<[Track]>
}

final class TracksProvider: TracksProviding {
    private let 
    func tracks(for query: String) -> PrimitiveSequence<SingleTrait, [Track]> {

    }
}
