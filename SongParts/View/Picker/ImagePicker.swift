//
//  ImagePicker.swift
//  SongParts
//
//  Created by Lucas Ference on 6/17/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Photos
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    enum MediaType: String {
        case image = "public.image"
        case video = "public.movie"
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var url: URL?
    
    let mediaTypes: [MediaType]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = self.mediaTypes.map{ $0.rawValue }
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let mediaUrl = info[.mediaURL] as? NSURL {
                self.parent.url = mediaUrl.absoluteURL
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
