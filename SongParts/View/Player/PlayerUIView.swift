//
//  PlayerUiView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/15/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerUIView: UIView {
    
    private let playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
