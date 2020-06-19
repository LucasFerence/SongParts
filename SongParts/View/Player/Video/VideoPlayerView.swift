//
//  Player.swift
//  SongParts
//
//  Created by Lucas Ference on 6/15/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import SwiftUI

struct VideoPlayerView: UIViewRepresentable {
    
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let uiView = VideoPlayerUIView(player: player,
                                       videoPos: $videoPos,
                                       videoDuration: $videoDuration,
                                       seeking: $seeking)
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // This function gets called if the bindings change, which could be useful if
        // you need to respond to external changes, but we don't in this example
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        guard let playerUIView = uiView as? VideoPlayerUIView else {
            return
        }
        
        playerUIView.cleanUp()
    }
}
