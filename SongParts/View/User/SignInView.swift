//
//  SignInView.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct SignInView : View {
    
    @EnvironmentObject var session: SessionStore

    @State private var email: String = ""
    @State private var password: String = ""
    
    // -- Error states --
    @State private var error: Error?
    
    // -- Transition states --
    @State var signInSuccess = false
    @State var newUser = false

    func signIn() {
        session.signIn(email: email, password: password) { (result, err) in
            if err != nil {
                self.error = Error(message: err!.localizedDescription)
            } else {
                self.signInSuccess = true
            }
        }
    }

    var body: some View {
        Group {
            if (newUser) {
                NewUserView()
            } else {
                VStack {
                    Text("Sign in")
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
                    
                    Spacer()
                    
                    Button(action: signIn) {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }
                    .padding()
                                    
                    Button("New User") {
                        self.newUser = true
                    }
                    
                    Spacer()
                }
                .padding([.leading, .trailing], 30.0)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
                .alert(item: $error) { err in
                    Alert(title: Text("Error"), message: Text(err.message))
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
