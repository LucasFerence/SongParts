//
//  Player.swift
//  SongParts
//
//  Created by Lucas Ference on 6/15/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct PlayerView: UIViewRepresentable {
    
    private let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: self.player)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing
    }
}
