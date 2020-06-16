//
//  ViewUnwrapper.swift
//  SongParts
//
//  Created by Lucas Ference on 6/7/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct Unwrap<Value, Content: View>: View {
    
    private let value: Value?
    private let contentProvider: (Value) -> Content

    init(_ value: Value?,
         @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }

    var body: some View {
        value.map(contentProvider)
    }
}
