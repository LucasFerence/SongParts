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
    
    private let cameraController: CameraControllerRepresentable
    
    init(url: Binding<URL?>) {
        self._url = url
        self.cameraController = CameraControllerRepresentable(url: self._url)
    }
    
    var body: some View {
        ZStack {
            cameraController
            
            VStack {
                Spacer()
                
                _PrimaryButton(title: "Start") {
                    self.cameraController.startRecording()
                }
                
                _PrimaryButton(title: "Stop") {
                    self.cameraController.stopRecording()
                }
            }
        }
    }
}
