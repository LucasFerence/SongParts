//
//  TextModifiers.swift
//  SongParts
//
//  Created by Lucas Ference on 6/8/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct TitleText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(Font.largeTitle.weight(.bold))
            .foregroundColor(.cometChatBlue)
    }
}

struct BodyText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.body)
    }
}
