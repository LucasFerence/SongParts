//
//  DocumentPickerViewController.swift
//  SongParts
//
//  Created by Lucas Ference on 6/12/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIViewController, DocumentDelegate {
    
    var documentPicker: DocumentPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentPicker = DocumentPicker(presentationController: self, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        documentPicker.present()
    }
    
    func didPickDocuments(documents: [Document]?) {
        print("Picked documents!")
    }
}
