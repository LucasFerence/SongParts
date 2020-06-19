//
//  Utility.swift
//  SongParts
//
//  Created by Lucas Ference on 6/19/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Foundation

class PlayerTimeUtils: NSObject {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        guard !seconds.isNaN,
            let text = timeHMSFormatter.string(from: seconds) else {
                return "00:00"
        }
        
        return text
    }
    
}
