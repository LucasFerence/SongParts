//
//  ContentView.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var session: SessionStore
    
    @State private var newUser = false
    @State private var signInSuccess = false

    func getUser() {
        session.listen()
    }

    var body: some View {
        Group {
            if (session.session != nil) {
                SignOutView()
            } else if (newUser) {
                NewUserView(signInSuccess: $signInSuccess)
            } else {
                SignInView(newUser: $newUser, signInSuccess: $signInSuccess)
            }
        }
        .onAppear(perform: getUser)
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
