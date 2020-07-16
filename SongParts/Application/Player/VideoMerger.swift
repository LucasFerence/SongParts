//
//  VideoMerger.swift
//  SongParts
//
//  Created by Lucas Ference on 7/13/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import MediaPlayer

typealias videoMergeCompletion = (_ mergedVideoURL: URL?, _ error: Error?) -> Void

class VideoMerger {
    
    static func merge(videoFileURLs: [URL], videoResolution: CGSize, completion: @escaping videoMergeCompletion) {
        // TODO: Handle any amount of videos and dynamically merge
        // TODO: Figure out audio merging, I don't think this handles that
        // TODO: Change background/between video color to look better (its currently black)
        
        if videoFileURLs.count != 4 {
            return
        }
        
        let composition = AVMutableComposition()
        var maxTime = AVURLAsset(url: videoFileURLs[0], options: nil).duration
        for videoFileURL in videoFileURLs {
            let options = [
                AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true)
            ]
            let asset = AVURLAsset(url: videoFileURL, options: options)
            if CMTimeCompare(maxTime, asset.duration) == -1 {
                maxTime = asset.duration
            }
        }
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: .zero, duration: maxTime)
        
        var arrAVMutableVideoCompositionLayerInstruction: [AVMutableVideoCompositionLayerInstruction] = []
        for i in 0 ..< videoFileURLs.count {
            
            let videoFileURL = videoFileURLs[i]
            let asset = AVURLAsset(url: videoFileURL, options: nil)
            
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
            
            var scale = CGAffineTransform(scaleX: 1, y: 1)
            var move = CGAffineTransform(translationX: 0, y: 0)
            
            var tx : CGFloat = 0
            if videoResolution.width / 2 - (videoTrack.naturalSize.width) != 0 {
                tx = ((videoResolution.width / 2 - (videoTrack.naturalSize.width)) / 2)
            }
            
            var ty : CGFloat = 0
            if videoResolution.height / 2 - (videoTrack.naturalSize.height) != 0 {
                ty = ((videoResolution.height / 2 - (videoTrack.naturalSize.height)) / 2)
            }

            if tx != 0 && ty != 0 {
                if tx <= ty {
                    let factor = CGFloat(videoResolution.width / 2 / videoTrack.naturalSize.width)
                    scale = CGAffineTransform(scaleX: CGFloat(factor), y: CGFloat(factor))
                    tx = 0
                    ty = (videoResolution.height / 2 - videoTrack.naturalSize.height * factor) / 2
                }
                if tx > ty {
                    let factor = CGFloat(videoResolution.height / 2 / videoTrack.naturalSize.height)
                    scale = CGAffineTransform(scaleX: factor, y: factor)
                    ty = 0
                    tx = (videoResolution.width / 2 - videoTrack.naturalSize.width * factor) / 2
                }
            }
            
            switch i {
                case 0:
                    move = CGAffineTransform(translationX: CGFloat(0 + tx), y: 0 + ty)
                case 1:
                    move = CGAffineTransform(translationX: videoResolution.width / 2 + tx, y: 0 + ty)
                case 2:
                    move = CGAffineTransform(translationX: 0 + tx, y: videoResolution.height / 2 + ty)
                case 3:
                    move = CGAffineTransform(translationX: videoResolution.width / 2 + tx, y: videoResolution.height / 2 + ty)
                default:
                    break
            }
            
            subInstruction.setTransform(scale.concatenating(move), at: .zero)
            arrAVMutableVideoCompositionLayerInstruction.append(subInstruction)
            
            instruction.layerInstructions = arrAVMutableVideoCompositionLayerInstruction.reversed()
        }
        
        let mainCompositionInst = AVMutableVideoComposition()
        mainCompositionInst.instructions = [instruction]
        mainCompositionInst.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainCompositionInst.renderSize = videoResolution
        
        let url = URL(fileURLWithPath: VideoMerger.generateMergedVideoFilePath())
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputURL = url
        exporter?.videoComposition = mainCompositionInst
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
                        print("Successfully merged: %@", exportSession.outputURL ?? "")
                        exportCompletion()
                    case .failed:
                        print("Failed %@",exportSession.error ?? "")
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
    
    fileprivate static func generateMergedVideoFilePath() -> String {
        return URL(fileURLWithPath: ((FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)?.path)!).appendingPathComponent("\(UUID().uuidString)-mergedVideo.mp4").path
    }
}
