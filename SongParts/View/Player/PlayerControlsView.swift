//
//  PlayerControlsView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/18/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct PlayerControlsView : View {
    
    @State var playerPaused = true

    let player: AVPlayer
    
    var body: some View {
        Button(action: {
            self.playerPaused.toggle()
            if self.playerPaused {
                self.player.pause()
            }
            else {
                self.player.play()
            }
        }) {
            Image(systemName: playerPaused ? "play" : "pause")
        }
    }
}
