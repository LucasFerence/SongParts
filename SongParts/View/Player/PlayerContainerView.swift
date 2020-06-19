//
//  PlayerContainerView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/18/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct PlayerContainerView: View {
    
    private let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    var body: some View {
        VStack {
            PlayerView(player: player)
            PlayerControlsView(player: player)
        }
    }
}
