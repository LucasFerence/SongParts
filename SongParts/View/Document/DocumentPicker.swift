//
//  DocumentPicker.swift
//  SongParts
//
//  Created by Lucas Ference on 6/15/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Foundation
import MobileCoreServices
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            documentTypes: [kUTTypeMovie as String, kUTTypeImage as String],
            in: .open
        )
        
        return picker
    }

    func updateUIViewController(_ vc: UIDocumentPickerViewController, context: Context) {
        // Do nothing right now
    }
    
    func didPickDocuments(documents: [UIDocument]?) {
        // Do something here
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        
        var parent: DocumentPicker
        var documents: [UIDocument]
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
            self.documents = [UIDocument]()
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                return
            }
            
            documentFromURL(pickedURL: url)
            parent.didPickDocuments(documents: documents)
        }
        
        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.didPickDocuments(documents: nil)
        }
        
        private func documentFromURL(pickedURL: URL) {
            let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
            
            defer {
                if shouldStopAccessing {
                    pickedURL.stopAccessingSecurityScopedResource()
                }
            }
            
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                let document = UIDocument(fileURL: pickedURL)
                documents.append(document)
            }
        }
    }
}
