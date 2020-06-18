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
    @State private var image: Image?
    
    @State private var signOutSuccess = false
    @State private var isPickerShown = false
    
    var body: some View {
        Group {
            if (signOutSuccess) {
                WelcomeView()
            } else {
                VStack {
                    Spacer()
                    
                    image?
                        .resizable()
                        .scaledToFit()
                    
                    _PrimaryButton(title: "Select Image") {
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
                .sheet(isPresented: $isPickerShown, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}
