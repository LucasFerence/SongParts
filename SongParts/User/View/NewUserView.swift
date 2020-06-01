//
//  NewUserView.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var loading = false
    @State var error: String? = nil
    @State var loggedIn = false

    @EnvironmentObject var session: SessionStore

    func createAccount() {
        loading = true
        error = ""
        if (password == confirmPassword) {
            session.createAccount(email: email, password: password) { (result, err) in
                self.loading = false
                
                if err != nil {
                    self.error = err?.localizedDescription
                } else {
                    self.loggedIn = true
                }
            }
        } else {
            error = "Passwords did not match"
        }
    }

    var body: some View {
        VStack {
            if (loggedIn) {
                ContentView()
            } else {
                TextField("Enter your email", text: $email)
                SecureField("Enter your password", text: $password)
                SecureField("Confirm password", text: $confirmPassword)
                
                if (error != nil) {
                    Text(error!)
                }
                
                Button(action: createAccount) {
                    Text("Create Account")
                }
            }
        }
    }
}
