//
//  WelcomeView.swift
//  SongParts
//
//  Created by Lucas Ference on 6/8/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    private enum PresentedView {
      case login
      case register
    }
    
    @State private var presentedView: PresentedView?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Share music with others around the world")
                .modifier(TitleText())
                .padding([.bottom, .leading, .trailing])
            
            Spacer()
          
            VStack(spacing: 30) {
                NavigationLink(destination: EmptyView()) {
                    PrimaryButton(title: "Log In")
                }
          
                NavigationLink(destination: EmptyView()) {
                    SecondaryButton(title: "Sign Up")
                }
            }
            .padding([.leading, .bottom, .trailing])
            .padding(.top, 40)
          
            Spacer()
        }
        .navigationBarTitle("Welcome")
    }
}

struct WelcomeView_Previews: PreviewProvider {
    
  static var previews: some View {
    Group {
        NavigationView {
            WelcomeView()
        }
    }
  }
}
