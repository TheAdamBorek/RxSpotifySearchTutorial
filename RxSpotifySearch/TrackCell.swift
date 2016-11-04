//
//  TrackCell.swift
//  RxSpotifySearch
//
//  Created by Adam Borek on 04/11/2016.
//  Copyright © 2016 Adam Borek. All rights reserved.
//

import UIKit

protocol TrackCellRendering {
    func render(trackRenderable renderable: TrackRenderableType)
}

class TrackCell: UITableViewCell, TrackCellRendering {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func render(trackRenderable renderable: TrackRenderableType) {
        topLabel.text = renderable.title
        bottomLabel.text = renderable.bottomText
    }
}
