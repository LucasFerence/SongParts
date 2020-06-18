//
//  Player.swift
//  SongParts
//
//  Created by Lucas Ference on 6/15/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct Player: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: AVPlayer(url: self.url))
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing
    }
}
