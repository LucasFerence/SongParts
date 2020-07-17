//
//  HomeView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/9/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

let cloudfrontURL = "http://d2gl5jmebl6p7o.cloudfront.net/D666F12F-C31A-47C3-872D-AD122E641DBC-85537-0000CA126627E594.MOV"

struct HomeView: View {
    
    @EnvironmentObject private var session: SessionStore
        
    @State private var inputImage: UIImage?
    
    @State private var url: URL?
    @State private var downloadUrl : URL?
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
                        self.mergeVideos()
                    }
                    .padding(.bottom)
                    
                    _PrimaryButton(title: "Select Video") {
                        self.isPickerShown = true
                    }
                    .padding(.bottom)
                                        
                    _PrimaryButton(title: "Download Default Video") {
                        self.downloadUrl = URL(string: cloudfrontURL)
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
    
    func mergeVideos() {
        VideoMerger.shared.merge(
            videoFileURLs: [url!, url!, url!, url!],
            videoResolution: CGSize(width: 640, height: 480)
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
