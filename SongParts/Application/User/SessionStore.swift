//
//  SessionStore.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
    
    @Published var session: User? { didSet { self.didChange.send(self) } }
    
    let didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    func isAvailable() -> Bool {
        return session != nil
    }

    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email
                )
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }
    
    func createAccount(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
