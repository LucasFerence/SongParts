//
//  DocumentPicker.swift
//  SongParts
//
//  Created by Lucas Ference on 6/11/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

open class DocumentPicker: NSObject {
    
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    private weak var delegate: DocumentDelegate?
    
    private var folderURL: URL?
    private var sourceType: SourceType!
    private var documents = [Document]()
    
    init(presentationController: UIViewController, delegate: DocumentDelegate) {
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    public func present() {
        let alertController = UIAlertController(
            title: "Select From",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        if let action = self.fileAction(for: .files, title: "Files") {
            alertController.addAction(action)
        }
        
        
        if let action = self.folderAction(for: .folder, title:
            "Folder") {
            alertController.addAction(action)
        }
        
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    public func folderAction(for type: SourceType, title: String) -> UIAlertAction? {
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            
            self.pickerController = UIDocumentPickerViewController(
                documentTypes: [kUTTypeFolder as String],
                in: .open
            )
            
            self.pickerController!.delegate = self
            self.sourceType = type
            
            self.presentationController?.present(self.pickerController!, animated: true)
        }
    }
    
    public func fileAction(for type: SourceType, title: String) -> UIAlertAction? {
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            
            self.pickerController = UIDocumentPickerViewController(
                documentTypes: [kUTTypeMovie as String, kUTTypeImage as String],
                in: .open
            )
                    
            self.pickerController!.delegate = self
            self.pickerController!.allowsMultipleSelection = true
            self.sourceType = type
                                        
            self.presentationController?.present(self.pickerController!, animated: true)
        }
    }
}

extension DocumentPicker: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        
        documentFromURL(pickedURL: url)
        delegate?.didPickDocuments(documents: documents)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.didPickDocuments(documents: nil)
    }
    
    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
            let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
            let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)

            switch sourceType {
            case .files:
                let document = Document(fileURL: pickedURL)
                documents.append(document)
            
            case .folder:
                for case let fileURL as URL in fileList! {
                    if !fileURL.isDirectory {
                        let document = Document(fileURL: fileURL)
                        documents.append(document)
                    }
                }
            case .none:
                break
            }
        }
    }
}

extension DocumentPicker: UINavigationControllerDelegate {}
