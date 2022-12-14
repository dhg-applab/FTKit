import SwiftUI
import ARKit

public final class FTKit {
    
    public static var shared = FTKit()
    public var overrideConfiguration: ARConfiguration? = nil
    public var overrideRunOptions: ARSession.RunOptions? = nil
    public var dataHandler: ((FTData) -> Void)? {
        didSet {
            controller.dataHandler = dataHandler
        }
    }
    
    public private(set) var controller = FTController()
    
    public func start() {
        let configuration = overrideConfiguration ?? controller.configuration
        let runOptions = overrideRunOptions ?? [.resetTracking, .removeExistingAnchors]
        
        guard let configuration = configuration else { return }
        
        controller.sceneView?.session.run(configuration, options: runOptions)
    }
    
    public func start(hiddenOnView view: UIView) {
        let arview = ARSCNView()
        controller.sceneView = arview
        
        DispatchQueue.main.async {
            view.addSubview(arview)
        }
        
        let configuration = overrideConfiguration ?? controller.configuration
        let runOptions = overrideRunOptions ?? [.resetTracking, .removeExistingAnchors]
        guard let configuration = configuration else { return }
        
        controller.sceneView?.rendersContinuously = false
        controller.sceneView?.antialiasingMode = .none
        controller.sceneView?.scene.background.contents = UIColor.clear
        controller.sceneView?.session.run(configuration, options: runOptions)
    }
    
    public func stop() {
        controller.sceneView?.session.pause()
    }
   
    public func reset() {
        stop()
        controller.sceneView = nil
        controller = FTController()
        controller.dataHandler = dataHandler
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
