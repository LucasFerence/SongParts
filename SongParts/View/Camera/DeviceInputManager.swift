//
//  DeviceInput.swift
//  SongParts
//
//  Created by Lucas Ference on 8/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation

/*
 Provides a wrapper implementation for managing devices and inputs
 */
class DeviceInputManager: NSObject {
    
    var device: AVCaptureDevice!
    var input: AVCaptureInput!
    
    var id: String!
    
    private override init () { }
    
    func addToSession(_ session: AVCaptureSession) {
        if (!session.canAddInput(self.input)) {
            fatalError("Could not add device [\(String(describing: self.id))] to session")
        }
        
        session.addInput(self.input)
    }
    
    static func create(device: AVCaptureDevice?, id: String) -> DeviceInputManager {
        let manager = DeviceInputManager()
        
        // Create device
        if let d = device {
            manager.device = d
        } else {
            fatalError("Error processing device: [\(id)]")
        }
        
        // Create device input
        guard let input = try? AVCaptureDeviceInput(device: device!) else {
            fatalError("Error creating input for device: [\(id)]")
        }
        
        manager.input = input
        
        manager.id = id
        
        return manager
    }
}
