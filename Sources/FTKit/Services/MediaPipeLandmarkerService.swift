//
//  File.swift
//
//
//  Created by Leon Nissen on 18.01.24.
//

import Foundation
import AVFoundation
import MediaPipeTasksVision


class MediaPipeLandmarkerService: NSObject {
    
    private var faceLandmarker: FaceLandmarker?
    
    func setup() {
        guard let modelPath = Bundle.main.path(forResource: "face_landmarker", ofType: "task") else { return }
        
        let options = FaceLandmarkerOptions()
        options.runningMode = .liveStream
        options.baseOptions.modelAssetPath = modelPath
        options.faceLandmarkerLiveStreamDelegate = self
        
        do {
            faceLandmarker = try FaceLandmarker(options: options)
        } catch {
            print(error)
        }
    }
    
    func detectAsync(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation, timeStamps: Int) {
        guard let image = try? MPImage(sampleBuffer: sampleBuffer, orientation: orientation) else { return }
        do {
            try faceLandmarker?.detectAsync(image: image, timestampInMilliseconds: timeStamps)
        } catch {
            print(error)
        }
    }
}

extension MediaPipeLandmarkerService: FaceLandmarkerLiveStreamDelegate {
    func faceLandmarker(_ faceLandmarker: FaceLandmarker, didFinishDetection result: FaceLandmarkerResult?, timestampInMilliseconds: Int, error: Error?) {
        if let error = error {
            print(error)
        }
        
        guard let result = result else { return }
        
        guard let blendshapes = result.faceBlendshapes.first else { return }
        let blendshapesDict: [String: Float] = blendshapes.categories.reduce(into: [:]) { $0[$1.categoryName!] = $1.score }
        print(blendshapesDict)
    }
}
