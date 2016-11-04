//
//  ViewController.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 04/11/2016.
//  Copyright (c) 2016 Adam Borek. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class ViewController: UIViewController {

    var task: URLSessionDataTask? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        super.didReceiveMemoryWarning()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/search?q=the+heart+asks&type=track&market=US")!)
        request.httpMethod = "GET"
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        let task = session.dataTask(with: request) { data, response, error in
            let json = data.flatMap { data in
                return JSON(data: data)
            }
            print(json)
        }
        task.resume()

    }

    override func didReceiveMemoryWarning() {

    }
}

class SpotifyClient {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    func search(query: String, callback: @escaping ([Track]) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/search?q=\(query)&type=track&market=US")!)
        request.httpMethod = "GET"
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        let task = session.dataTask(with: request) { data, response, error in
            let tracks = data.flatMap(JSON.init)
                    .map(self.parseTracks)
        }
        task.resume()
        return task
    }


    private func parseTracks(json: JSON) -> [Track] {
        return Track.tracks(json: json["tracks"]["items"].array)
    }

}

class Track {
    let name: String
    let artist: String
    let album: String

    init(name: String, artist: String, album: String) {
        self.name = name
        self.artist = artist
        self.album = album
    }

    convenience init?(json: JSON) {
        guard let name = json["name"].string,
              let artist = json["artists"].array?.first?["name"].string,
              let album = json["album"]["name"].string else {
            return nil
        }
        self.init(name: name, artist: artist, album: album)
    }

    static func tracks(json: [JSON]?) -> [Track] {
        return json?.flatMap(Track.init) ?? []
    }
}

//curl -X GET "https://api.spotify.com/v1/search?q=the+heart+asks&type=track" -H "Accept: application/json"