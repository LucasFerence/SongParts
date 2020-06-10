//
//  ErrorTextField.swift
//  SongParts
//
//  Created by Lucas Ference on 6/8/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import SwiftUI

struct ErrorTextField: View {
    
    let title: String
    let placeholder: String
    let text: Binding<String>
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let isValid: (String) -> Bool
    
    init(title: String,
         placeholder: String,
         text: Binding<String>,
         keyboardType: UIKeyboardType = UIKeyboardType.default,
         isSecure: Bool = false,
         isValid: @escaping (String)-> Bool = { _ in true}) {
        
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.isValid = isValid
    }
    
    var showsError: Bool {
        if text.wrappedValue.isEmpty {
            return false
        } else {
            return !isValid(text.wrappedValue)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .foregroundColor(Color(.lightGray))
                .fontWeight(.bold)
            
            HStack {
                
                if (isSecure) {
                    SecureField(placeholder, text: text)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                } else {
                    TextField(placeholder, text: text)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                }
            }
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(showsError ? .red : Color(red: 189 / 255, green: 204 / 255, blue: 215 / 255))
        }
    }
}

struct ErrorTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ErrorTextField(
                title: "Email",
                placeholder: "test@email.com",
                text: .constant(""))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            ErrorTextField(
                title: "Email",
                placeholder: "test@email.com",
                text: .constant("some@email.com"))
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
            
            ErrorTextField(
                title: "Email",
                placeholder: "test@email.com",
                text: .constant("some@email.com"),
                isValid: { _ in false })
                .padding()
                .previewLayout(.fixed(width: 400, height: 100))
        }
    }
}
