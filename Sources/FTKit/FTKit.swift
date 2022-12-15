import SwiftUI
import ARKit



public struct FTConfiguration {
    let dataHandler: ((FTData) -> Void)?
    let arConfiguration: ARConfiguration?
    let runOptions: ARSession.RunOptions?
    let enableLightEstimate: Bool
    let captureBlendShapes: Bool
    let captureLookAtPoint: Bool
    let captureDepthMap: Bool
    let captureFaceVertices: Bool
    let faceGeometryVertices: [Int]
    
    public init(dataHandler: ((FTData) -> Void)?,
                arConfiguration: ARConfiguration? = nil,
                runOptions: ARSession.RunOptions? = nil,
                enableLightEstimate: Bool = true,
                captureBlendShapes: Bool = true,
                captureLookAtPoint: Bool = true,
                captureDepthMap: Bool = true,
                captureFaceVertices: Bool = true,
                faceGeometryVertices: [Int] = []) {
        self.dataHandler = dataHandler
        self.arConfiguration = arConfiguration
        self.runOptions = runOptions
        self.enableLightEstimate = enableLightEstimate
        self.captureBlendShapes = captureBlendShapes
        self.captureLookAtPoint = captureLookAtPoint
        self.captureDepthMap = captureDepthMap
        self.captureFaceVertices = captureFaceVertices
        self.faceGeometryVertices = faceGeometryVertices
    }
}

public final class FTKit {
    
    public static var shared = FTKit()
    public var configuration: FTConfiguration? {
        didSet {
            controller.configuration = configuration
        }
    }
    
    public private(set) var controller = FTController()
    
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
