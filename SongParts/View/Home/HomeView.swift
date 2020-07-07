//
//  HomeView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/9/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var session: SessionStore
        
    @State private var inputImage: UIImage?
    @State private var url: URL?
    
    @State private var signOutSuccess = false
    @State private var isPickerShown = false
    
    var body: some View {
        Group {
            if (signOutSuccess) {
                WelcomeView()
            } else {
                VStack {
                    Spacer()
                    
                    if (self.url != nil) {
                        VideoView(url: self.url!)
                        
                        _PrimaryButton(title: "Upload Video") {
                            self.uploadVideo()
                        }
                    }
                    
                    _PrimaryButton(title: "Select Video") {
                        self.isPickerShown = true
                    }
                    
                    Spacer()
                    
                    _PrimaryButton(title: "Log Out") {
                        if (self.session.signOut()) {
                            self.signOutSuccess = true
                        }
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $isPickerShown) {
                    ImagePicker(url: self.$url, mediaTypes: [.video])
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func uploadVideo() {
        AWSS3Manager.shared.uploadVideo(videoUrl: url!, progress: nil) { (uploadedFileUrl, error) in
            if let finalPath = uploadedFileUrl as? String {
                print(finalPath)
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }
}
