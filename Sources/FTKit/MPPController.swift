////
////  File.swift
////  
////
////  Created by Leon Nissen on 18.01.24.
////
//
//import AVFoundation
//import MediaPipeTasksVision
//
//class MPPController: NSObject {
//    private var isSessionRunning = false
//    private var isObserving = false
//    private let backgroundQueue = DispatchQueue(label: "com.google.mediapipe.cameraController.backgroundQueue")
//    
//    private lazy var cameraFeedService = MediaPipeCameraService()
//    private let faceLandmarkerServiceQueue = DispatchQueue(
//      label: "com.google.mediapipe.cameraController.faceLandmarkerServiceQueue",
//      attributes: .concurrent)
//    
//    private var _landmarkerService: MediaPipeLandmarkerService?
//    private var landmarkerService: MediaPipeLandmarkerService? {
//        get {
//            faceLandmarkerServiceQueue.sync {
//                return self._landmarkerService
//            }
//        }
//        set {
//            faceLandmarkerServiceQueue.sync(flags: .barrier) {
//                self._landmarkerService = newValue
//            }
//        }
//    }
//    
//    func start() {
//        cameraFeedService.delegate = self
//        initLandmarkerService()
//        guard landmarkerService != nil else { return }
//        landmarkerService!.setup()
//        cameraFeedService.startLiveCameraSession { cameraConfiguration in
//            print(cameraConfiguration)
//        }
//        
//    }
//    
//    func stop() {
//        cameraFeedService.stopSession()
//        landmarkerService = nil
//    }
//    
//    func initLandmarkerService() {
//        landmarkerService = nil
//        landmarkerService = MediaPipeLandmarkerService()
//    }
//    
//    
//}
//
//extension MPPController: CameraFeedServiceDelegate {
//    func didOutput(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation) {
//        let currentTimeMs = Date().timeIntervalSince1970 * 1000
//        
//        backgroundQueue.async { [weak self] in
//            self?.landmarkerService?
//                .detectAsync(sampleBuffer: sampleBuffer,
//                             orientation: orientation,
//                             timeStamps: Int(currentTimeMs))
//        }
//    }
//    
//    func didEncounterSessionRuntimeError() {
//        stop()
//    }
//    
//    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
//        stop()
//    }
//    
//    func sessionInterruptionEnded() {
//        stop()
//    }
//}
