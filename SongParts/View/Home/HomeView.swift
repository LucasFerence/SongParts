//
//  HomeView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/9/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

let cloudfrontURL = "http://d2gl5jmebl6p7o.cloudfront.net/D666F12F-C31A-47C3-872D-AD122E641DBC-85537-0000CA126627E594.MOV"

/*
 This view obviously needs to be redone entirely. It is acting as a playground for now.
 */
struct HomeView: View {
    
    @EnvironmentObject private var session: SessionStore
        
    @State private var inputImage: UIImage?
    
    @State private var firstVideo: URL?
    @State private var secondVideo: URL?
    
    @State private var url: URL?
    @State private var exportUrl: URL?
    
    @State private var signOutSuccess = false
    @State private var isPickerShown = false
    
    var body: some View {
        Group {
            if (signOutSuccess) {
                WelcomeView()
            } else {
                VStack {
                    Spacer()
                    
                    if (self.exportUrl != nil) {
                        VideoView(url: self.exportUrl!)
                            .padding(.bottom)
                    }
                    
                    _PrimaryButton(title: "Merge Videos") {
                        if self.firstVideo != nil && self.secondVideo != nil {
                            self.mergeVideos()
                        }
                    }
                    .padding(.bottom)
                    
                    _PrimaryButton(title: "Record Video") {
                        self.isPickerShown = true
                    }
                    .padding(.bottom)
                    
                    Spacer()
                    
                    _PrimaryButton(title: "Log Out") {
                        if (self.session.signOut()) {
                            self.signOutSuccess = true
                        }
                    }
                }
                .sheet(isPresented: $isPickerShown) {
                    if self.firstVideo == nil {
                        CameraView(url: self.$firstVideo)
                    } else if self.secondVideo == nil {
                        CameraView(url: self.$secondVideo)
                        
                        // Play the first video for fun :)
                        // Eventually it will need to do this so you can record over
                        // Really just need to figure out how to trigger the other video to play when recording starts
                        VideoView(url: self.firstVideo!)
                            .padding(.bottom)
                    }
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
    
    func mergeVideos() {
        VideoMerger.shared.mergeTwo(
            videoFileURLs: [firstVideo!, secondVideo!],
            videoResolution: CGSize(width: 720, height: 480)
        ) { (export, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                self.exportUrl = export
                return
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
