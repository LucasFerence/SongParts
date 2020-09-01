//
//  CameraView.swift
//  SongParts
//
//  Created by Lucas Ference on 8/30/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @Binding var url: URL?
    
    var body: some View {
        ZStack {
            CameraControllerRepresentable(url: $url)
            
            VStack {
                Spacer()
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 50)
            }
        }
    }
}
