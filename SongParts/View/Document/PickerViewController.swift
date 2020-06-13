//
//  PickerViewController.swift
//  SongParts
//
//  Created by Lucas Ference on 6/12/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct PickerViewController: UIViewControllerRepresentable {
    
    var controller: UIViewController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DocumentPickerViewController {
        return DocumentPickerViewController()
    }
    
    func updateUIViewController(_ viewController: DocumentPickerViewController, context: Context) {
        print("update VC")
    }
    
    class Coordinator: NSObject {
        
        var parent: PickerViewController

        init(_ pickerViewController: PickerViewController) {
            self.parent = pickerViewController
        }
    }
}
