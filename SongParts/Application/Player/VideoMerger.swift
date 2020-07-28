//
//  VideoMerger.swift
//  SongParts
//
//  Created by Lucas Ference on 7/13/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import MediaPlayer

typealias videoMergeCompletion = (_ mergedVideoURL: URL?, _ error: Error?) -> Void

enum MergeError: Error {
    case urlCount
    case unmatchedTransforms
}

class VideoMerger {
    
    static let shared = VideoMerger()
    private init() { }
    
    func mergeTwo(videoFileURLs: [URL], videoResolution: CGSize, completion: @escaping videoMergeCompletion) {
        if videoFileURLs.count != 2 {
            DispatchQueue.main.async { completion(nil, MergeError.urlCount) }
        }
    
        var transforms: [CGAffineTransform] = []
        
        let rotationAngle = CGFloat.pi / 2
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
             
        // These translations don't make sense, but they are working I suppose.
        transforms.append(
            scale.translatedBy(x: 400, y: 0).rotated(by: rotationAngle)
        )
        transforms.append(
            scale.translatedBy(x: videoResolution.width + 400, y: 0).rotated(by: rotationAngle)
        )
        
        merge(videoFileURLs: videoFileURLs, transforms: transforms, videoResolution: videoResolution, completion: completion)
    }

    private func merge(videoFileURLs: [URL], transforms: [CGAffineTransform], videoResolution: CGSize, completion: @escaping videoMergeCompletion) {
        if (videoFileURLs.count != transforms.count) {
            DispatchQueue.main.async { completion(nil, MergeError.unmatchedTransforms) }
        }
        
        let composition = AVMutableComposition()
        var maxTime = AVURLAsset(url: videoFileURLs[0], options: nil).duration
        
        let options = [
            AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true)
        ]
        let assets = videoFileURLs.map { AVURLAsset(url: $0, options: options) }
        
        for asset in assets {
            if CMTimeCompare(maxTime, asset.duration) == -1 {
                maxTime = asset.duration
            }
        }
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero, duration: maxTime)
        
        var arrAVMutableVideoCompositionLayerInstruction: [AVMutableVideoCompositionLayerInstruction] = []
        
        for i in 0 ..< assets.count {
            
            let asset = assets[i]
                                    
            guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                return
            }
            
            do {
                try videoTrack.insertTimeRange(
                    CMTimeRangeMake(start: .zero, duration: maxTime),
                    of: asset.tracks(withMediaType: .video)[0],
                    at: .zero
                )
            } catch {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let subInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
            
            subInstruction.setTransform(transforms[i], at: .zero)
            arrAVMutableVideoCompositionLayerInstruction.append(subInstruction)
            
            instruction.layerInstructions = arrAVMutableVideoCompositionLayerInstruction.reversed()
        }
        
        let mainCompositionInst = AVMutableVideoComposition()
        mainCompositionInst.instructions = [instruction]
        mainCompositionInst.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainCompositionInst.renderSize = videoResolution
        
        exportVideo(
            asset: composition,
            composition: mainCompositionInst,
            completion: completion
        )
    }
    
    private func computeTransform(at index: Int, outputSize: CGSize, trackSize: CGSize) -> CGAffineTransform {
        var scale = CGAffineTransform(scaleX: 1, y: 1)
        var move = CGAffineTransform(translationX: 0, y: 0)
        
        // tx and ty represent the transform values of the video track. These are necessary if
        // the videos do not perfectly fit into the defined resolution
        
        var tx : CGFloat = 0
        if outputSize.width / 2 - (trackSize.width) != 0 {
            tx = ((outputSize.width / 2 - (trackSize.width)) / 2)
        }

        var ty : CGFloat = 0
        if outputSize.height / 2 - (trackSize.height) != 0 {
            ty = ((outputSize.height / 2 - (trackSize.height)) / 2)
        }

        if tx != 0 && ty != 0 {
            if tx <= ty {
                let factor = CGFloat(outputSize.width / 2 / trackSize.width)
                scale = CGAffineTransform(scaleX: CGFloat(factor), y: CGFloat(factor))
                tx = 0
                ty = (outputSize.height / 2 - trackSize.height * factor) / 2
            }
            if tx > ty {
                let factor = CGFloat(outputSize.height / 2 / trackSize.height)
                scale = CGAffineTransform(scaleX: factor, y: factor)
                ty = 0
                tx = (outputSize.width / 2 - trackSize.width * factor) / 2
            }
        }
        
        switch index {
            case 0:
                move = CGAffineTransform(translationX: CGFloat(0 + tx), y: outputSize.height / 2 + ty)
            case 1:
                move = CGAffineTransform(translationX: outputSize.width / 2 + tx, y: 0 + ty)
            case 2:
                move = CGAffineTransform(translationX: 0 + tx, y: outputSize.height / 2 + ty)
            case 3:
                move = CGAffineTransform(translationX: outputSize.width / 2 + tx, y: outputSize.height / 2 + ty)
            default:
                break
        }
        
        return scale.concatenating(move).rotated(by: CGFloat(Double.pi / 2))
    }
    
    private func generateMergedVideoFilePath(type: String) -> String {
        let basePath = ((FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)?.path)!
        let uuid = UUID().uuidString
        
        return URL(fileURLWithPath: basePath).appendingPathComponent("\(uuid).\(type)").path
    }
    
    private func exportVideo(
        asset: AVMutableComposition,
        composition: AVMutableVideoComposition,
        completion: @escaping videoMergeCompletion) {
        
        let url = URL(fileURLWithPath: generateMergedVideoFilePath(type: "mp4"))
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputURL = url
        exporter?.videoComposition = composition
        exporter?.outputFileType = .mp4
        
        let exportCompletion: (() -> Void) = {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                completion(exporter?.outputURL, exporter?.error)
            })
        }
        
        if let exportSession = exporter {
            exportSession.exportAsynchronously(completionHandler: { () -> Void in
                switch exportSession.status {
                    case .completed:
                        print("Successfully merged: \(String(describing: exportSession.outputURL))")
                        exportCompletion()
                    case .failed:
                        print("Failed \(String(describing: exportSession.error))")
                        exportCompletion()
                        return
                    case .cancelled:
                        print("Cancelled")
                        exportCompletion()
                    case .unknown:
                        print("Unknown")
                    case .exporting:
                        print("Exporting")
                    case .waiting:
                        print("Wating")
                    @unknown default:
                        print("default")
                }
            })
        }
    }
}
