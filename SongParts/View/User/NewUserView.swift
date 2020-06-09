//
//  NewUserView.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    
    @EnvironmentObject var session: SessionStore
    @Binding var signInSuccess: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var showingError = false
    @State private var error: String? = nil

    func createAccount() {
        if (password == confirmPassword) {
            session.createAccount(email: email, password: password) { (result, err) in
                if err != nil {
                    self.showingError = true
                    self.error = err?.localizedDescription
                } else {
                    self.signInSuccess = true
                }
            }
        } else {
            self.showingError = true
            self.error = "Passwords did not match"
        }
    }

    var body: some View {
        VStack {
            Text("New User")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.black)
                .padding([.top, .bottom], 40)
            
            Spacer()
            
            TextField("Enter your email", text: $email)
                .padding()
                .background(Color.white)
                .keyboardType(.emailAddress)
                .cornerRadius(20.0)
                            
            SecureField("Enter your password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
            
            SecureField("Confirm password", text: $confirmPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
            
            Spacer()
            
            Button(action: createAccount) {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .padding()
            
            Spacer()
        }
        .padding([.leading, .trailing], 30.0)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .alert(isPresented: $showingError) {
            Alert(title: Text("Error"), message: Text(error!))
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
        
    static var previews: some View {
        NewUserView(signInSuccess: .constant(false))
    }
}
