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
    
    @State private var signOutSuccess = false
    @State private var isPickerShown = false
    
    var body: some View {
        Group {
            if (signOutSuccess) {
                WelcomeView()
            } else {
                VStack {
                    Spacer()
                    
                    Button(action: openPicker) {
                        PrimaryButton(title: "Select Document")
                    }
                    
                    Spacer()
                    
                    _PrimaryButton(title: "Log Out") {
                        self.signOut()
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $isPickerShown) {
                    DocumentPickerView()
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func signOut() {
        if (session.signOut()) {
            signOutSuccess = true
        }
    }
    
    func openPicker() {
        self.isPickerShown = true
    }
}
