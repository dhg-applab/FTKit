import SwiftUI
import ARKit

public final class FTKit {
    
    public static var shared = FTKit()
    public var configuration: FTConfiguration? {
        didSet {
            controller.configuration = configuration
        }
    }
    
    public private(set) var controller = FTController()
    
//    private var mppController = MPPController()
//    
//    public func startMPP() {
//        mppController.start()
//    }
//    
//    public func stopMPP() {
//        mppController.stop()
//    }
    
    public func start() {
        let arConfiguration = configuration?.arConfiguration ?? controller.arConfiguration
        let runOptions = configuration?.runOptions ?? [.resetTracking, .removeExistingAnchors]
        
        guard let arConfiguration = arConfiguration else { return }
        
        controller.sceneView?.session.run(arConfiguration, options: runOptions)
    }
    
    public func start(hiddenOnView view: UIView) {
        let arview = ARSCNView()
        controller.sceneView = arview
        
        DispatchQueue.main.async {
            view.addSubview(arview)
        }
        
        let arConfiguration = configuration?.arConfiguration ?? controller.arConfiguration
        let runOptions = configuration?.runOptions ?? [.resetTracking, .removeExistingAnchors]
        
        guard let arConfiguration = arConfiguration else { return }
        
        controller.sceneView?.rendersContinuously = false
        controller.sceneView?.antialiasingMode = .none
        controller.sceneView?.scene.background.contents = UIColor.clear
        controller.sceneView?.session.run(arConfiguration, options: runOptions)
    }
    
    public func stop() {
        controller.sceneView?.session.pause()
    }
   
    public func reset() {
        stop()
        controller.sceneView = nil
        controller = FTController()
        controller.configuration = configuration
    }
    
    public func getUIKitView() -> FTViewController {
        let viewController = FTViewController()
        viewController.controller = controller
        return viewController
    }
    
    public func getSwiftUIView() -> FTViewIndicator {
        let viewController = FTViewController()
        viewController.controller = controller
        return FTViewIndicator(controller: viewController)
    }
}
