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
    
    func signOut() {
        if (session.signOut()) {
            signOutSuccess = true
        }
    }
    
    var body: some View {
        Group {
            if (signOutSuccess) {
                WelcomeView()
            } else {
                _PrimaryButton(title: "Log Out") {
                    self.signOut()
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
