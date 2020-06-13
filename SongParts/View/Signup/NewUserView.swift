//
//  LoginView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/9/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI
import Combine


struct NewUserView: View {
    
    @EnvironmentObject private var session: SessionStore
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var userCreated = false
    @State private var error: Error?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("New User")
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
            
            ErrorTextField(
                title: "Confirm Password",
                placeholder: "",
                text: $confirmPassword,
                keyboardType: .default,
                isSecure: true,
                isValid: isConfirmPasswordValid)
            
            Spacer()
            
            NavigationLink(destination: HomeView(), isActive: $userCreated) {
                Button(action: createUser) {
                    PrimaryButton(title: "Create User")
                }
            }
        }
        .padding()
        .alert(item: $error) { err in
            Alert(title: Text("Error"), message: Text(err.message))
        }
    }
    
    func isConfirmPasswordValid(_ confirm: String) -> Bool {
        return self.password == confirm
    }
    
    func createUser() {
        if (!isConfirmPasswordValid(confirmPassword)) {
            self.error = Error(message: "Passwords do not match")
        } else {
            session.createAccount(email: email, password: password) { (result, err) in
                if err != nil {
                    self.error = Error(message: err!.localizedDescription)
                } else {
                    self.userCreated = true
                }
            }
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewUserView()
    }
}

