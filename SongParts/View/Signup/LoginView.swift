//
//  LoginView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/9/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @EnvironmentObject private var session: SessionStore
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var loggedIn = false
    @State private var error: Error?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("Log In")
                .modifier(TitleText())
            
            ErrorTextField(
                title: "Email",
                placeholder: "mail@example.com",
                text: $email,
                keyboardType: .emailAddress)
            
            ErrorTextField(
                title: "Password",
                placeholder: "",
                text: $password,
                keyboardType: .default,
                isSecure: true)
            
            Spacer()
            
            NavigationLink(destination: HomeView(), isActive: $loggedIn) {
                Button(action: login) {
                    PrimaryButton(title: "Log In")
                }
            }
        }
        .padding()
        .alert(item: $error) { err in
            Alert(title: Text("Error"), message: Text(err.message))
        }
    }
    
    func isValid(val: String) -> Bool {
        return true
    }
    
    func login() {
        session.signIn(email: email, password: password) { (result, err) in
            if err != nil {
                self.error = Error(message: err!.localizedDescription)
            } else {
                self.loggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
}
