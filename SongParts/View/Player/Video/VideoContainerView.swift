//
//  PlayerContainerView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/18/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct VideoPlayerContainerView : View {
    
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    
    private let player: AVPlayer
  
    init(player: AVPlayer) {
        self.player = player
    }
  
    var body: some View {
        VStack {
            VideoPlayerView(videoPos: $videoPos,
                            videoDuration: $videoDuration,
                            seeking: $seeking,
                            player: player)
            VideoPlayerControlsView(videoPos: $videoPos,
                                    videoDuration: $videoDuration,
                                    seeking: $seeking,
                                    player: player)
        }
        .onDisappear {
            // When this View isn't being shown anymore stop the player
            self.player.replaceCurrentItem(with: nil)
        }
    }
}
