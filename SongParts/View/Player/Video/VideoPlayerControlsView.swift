//
//  PlayerControlsView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/18/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct VideoPlayerControlsView : View {
    
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    @State private var playerPaused = true
    
    var body: some View {
        HStack {
            // Play/pause button
            Button(action: togglePlayPause) {
                Image(systemName: playerPaused ? "play" : "pause")
                    .padding(.trailing, 10)
            }
            // Current video time
            Text("\(PlayerTimeUtils.formatSecondsToHMS(videoPos * videoDuration))")
            // Slider for seeking / showing video progress
            Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged)
            // Video duration
            Text("\(PlayerTimeUtils.formatSecondsToHMS(videoDuration))")
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    private func togglePlayPause() {
        pausePlayer(!playerPaused)
    }
    
    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Set a flag stating that we're seeking so the slider doesn't
            // get updated by the periodic time observer on the player
            seeking = true
            pausePlayer(true)
        }
        
        // Do the seek if we're finished
        if !editingStarted {
            let targetTime = CMTime(
                seconds: videoPos * videoDuration,
                preferredTimescale: 600
            )
            
            player.seek(to: targetTime) { _ in
                // Now the seek is finished, resume normal operation
                self.seeking = false
                self.pausePlayer(false)
            }
        }
    }
}
