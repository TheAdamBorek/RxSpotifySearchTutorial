//
//  TrackRenderable.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 04/11/2016.
//  Copyright © 2016 Adam Borek. All rights reserved.
//

import Foundation

protocol TrackRenderableType {
    var title: String { get }
    var bottomText: String { get }
}

struct TrackRenderable: TrackRenderableType {
    let title: String
    let bottomText: String
    
    init(title: String, bottomText: String) {
        self.title = title
        self.bottomText = bottomText
    }
    
    init(track: Track) {
        self.title = track.name
        self.bottomText = "\(track.artist) · \(track.album))"
    }
}
