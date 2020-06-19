//
//  VideoView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/19/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

// This is the main SwiftUI view for this app, containing a single PlayerContainerView
struct VideoView: View {

    private let player: AVPlayer
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    var body: some View {
        VideoPlayerContainerView(player: player)
    }
}
