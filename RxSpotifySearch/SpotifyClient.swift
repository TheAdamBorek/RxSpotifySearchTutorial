//
//  SpotifyClient.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 04/11/2016.
//  Copyright © 2016 Adam Borek. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class SpotifyClient {
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func search(query: String, callback: @escaping ([Track]) -> Void) -> URLSessionDataTask {
        let encodedQuery = encode(query: query) ?? ""
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&market=US")!)
        request.httpMethod = "GET"
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        let task = session.dataTask(with: request) { data, response, error in
            let tracks = data.flatMap { try? JSON(data: $0) }
                .map(self.parseTracks) ?? []
            callback(tracks)
        }
        task.resume()
        return task
    }
    
    private func encode(query: String) -> String? {
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.insert(charactersIn: " ")
        return query.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)?
            .replacingOccurrences(of: " ", with: "+")
    }
    
    
    private func parseTracks(json: JSON) -> [Track] {
        return Track.tracks(json: json["tracks"]["items"].array)
    }
}

extension SpotifyClient: ReactiveCompatible {}
extension Reactive where Base: SpotifyClient {
    func search(query: String) -> Observable<[Track]> {
        return Observable.create { observer in
            let request = self.base.search(query: query, callback: { tracks in
                observer.onNext(tracks)
            })
            return Disposables.create {
                request.cancel()
            }
        }.observeOn(MainScheduler.instance)
    }
}
