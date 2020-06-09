//
//  SignOutView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/4/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct SignOutView: View {
    
    @EnvironmentObject var session: SessionStore
    
    @State private var signOutSuccess = false
    
    func signOut() {
        if (session.signOut()) {
            signOutSuccess = true
        }
    }
    
    var body: some View {
        
        Group {
            if (signOutSuccess) {
                RootView()
            } else {
                Button(action: signOut) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .padding()
            }
        }
        
    }
}
