//
//  SignInView.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    @State var newUser = false

    @EnvironmentObject var session: SessionStore

    func signIn() {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }

    var body: some View {
        VStack {
            if (newUser) {
                NewUserView()
            } else {
                TextField("Enter your email", text: $email)
                SecureField("Enter your password", text: $password)
                
                if (error) {
                    Text("Error signing in")
                }
                
                Button(action: signIn) {
                    Text("Sign in")
                }
                
                Divider()
                Button("New User") {
                    self.newUser = true
                }
            }
        }
    }
}
