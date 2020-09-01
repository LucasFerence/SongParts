//
//  CameraViewController.swift
//  SongParts
//
//  Created by Lucas Ference on 8/30/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AVFoundation
import UIKit

protocol CameraControllerDelegate {
    func onFinishRecording(url: URL)
}

/*
 Based on this blog:
 https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563
 
 And this StackOverflow
 https://stackoverflow.com/questions/51209310/save-avcapturevideodataoutput-to-movie-file-using-avassetwriter-in-swift
 */
class CameraController: UIViewController {
    
    //MARK: Controller vars
    
    var delegate: CameraControllerDelegate?
    
    var isRecording = false
    var previewLayer: AVCaptureVideoPreviewLayer!
    var outputFileLocation: URL!
    
    //MARK: Video capture vars
    
    var captureSession: AVCaptureSession!
    
    var backCameraManager: DeviceInputManager!
    var frontCameraManager: DeviceInputManager!
    var audioManager: DeviceInputManager!
    
    var videoOutput: AVCaptureVideoDataOutput!
    var videoWriterInput: AVAssetWriterInput!
    
    var audioOutput: AVCaptureAudioDataOutput!
    var audioWriterInput: AVAssetWriterInput!
    
    var videoWriter: AVAssetWriter!
    
    var sessionAtSourceTime: CMTime!
    
        
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAndStartCaptureSession()
    }
    
    //MARK: Setup
    
    private func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            // Before setting a session presets, we should check if the session supports it
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputManagers()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.setupOutput()
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    private func setupInputManagers() {
        // Back camera
        self.backCameraManager = DeviceInputManager.create(
            device: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            id: "back-camera"
        )
        self.backCameraManager.addToSession(captureSession)
        
        // Audio
        self.audioManager = DeviceInputManager.create(
            device: AVCaptureDevice.default(for: .audio),
            id: "audio"
        )
        self.audioManager.addToSession(captureSession)
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
    }
    
    private func setupOutput() {
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        } else {
            fatalError("could not add audio output")
        }
    }
    
    func setupWriter() {
        do {
            outputFileLocation = getDefaultOutputLocation()
            videoWriter = try AVAssetWriter(outputURL: outputFileLocation!, fileType: AVFileType.mov)

            // add video input
            videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : 720,
                AVVideoHeightKey : 1280,
                AVVideoCompressionPropertiesKey : [
                    AVVideoAverageBitRateKey : 2300000,
                    ],
                ])

            videoWriterInput.expectsMediaDataInRealTime = true

            if videoWriter.canAdd(videoWriterInput) {
                videoWriter.add(videoWriterInput)
                print("video input added")
            } else {
                print("no input added")
            }

            // add audio input
            audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)

            audioWriterInput.expectsMediaDataInRealTime = true

            if videoWriter.canAdd(audioWriterInput!) {
                videoWriter.add(audioWriterInput!)
                print("audio input added")
            }

            videoWriter.startWriting()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: Utils
    
    private func canWrite() -> Bool {
        return isRecording && videoWriter != nil && videoWriter?.status == .writing
    }
    
    // Video file location method
    private func getDefaultOutputLocation() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("videoFile")).appendingPathExtension("mov")
        do {
            if FileManager.default.fileExists(atPath: videoOutputUrl.path) {
                try FileManager.default.removeItem(at: videoOutputUrl)
                print("File removed at default location")
            }
        } catch {
            print(error)
        }

        return videoOutputUrl
    }
    
    // MARK: Access
    
    func start() {
        guard !isRecording else { return }
                
        isRecording = true
        sessionAtSourceTime = nil
        setupWriter()

        if videoWriter.status == .writing {
            print("Status writing")
        } else if videoWriter.status == .failed {
            print("Status failed")
        } else if videoWriter.status == .cancelled {
            print("Status cancelled")
        } else if videoWriter.status == .unknown {
            print("Status unknown")
        } else {
            print("Status completed")
        }
    }
    
    func stop() {
        guard isRecording else { return }
        isRecording = false
        videoWriterInput.markAsFinished()
        
        videoWriter.finishWriting { [weak self] in
            self?.sessionAtSourceTime = nil
        }
        
        captureSession.stopRunning()
        
        delegate?.onFinishRecording(url: outputFileLocation)
    }
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let writable = canWrite()

        if (writable && sessionAtSourceTime == nil) {
            // start writing
            sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            videoWriter.startSession(atSourceTime: sessionAtSourceTime!)
        }

        if (output == videoOutput) {
            connection.videoOrientation = .portrait

            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
        }

        if (writable
            && output == videoOutput
            && (videoWriterInput.isReadyForMoreMediaData)) {
            // write video buffer
            videoWriterInput.append(sampleBuffer)
            
        } else if (writable
            && output == audioOutput
            && (audioWriterInput.isReadyForMoreMediaData)) {
            // write audio buffer
            audioWriterInput?.append(sampleBuffer)
        }
    }
}
