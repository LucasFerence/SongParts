//
//  CameraView.swift
//  SongParts
//
//  Created by Lucas Ference on 8/30/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct CameraControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var url: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CameraController {
        let controller = CameraController()
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ vc: CameraController, context: Context) {
        // Do nothing
    }
    
    class Coordinator: NSObject, CameraControllerDelegate {
        
        var parent: CameraControllerRepresentable

        init(_ parent: CameraControllerRepresentable) {
            self.parent = parent
        }
        
        func onFinishRecording(url: URL) {
            self.parent.url = url
        }
    }
}
