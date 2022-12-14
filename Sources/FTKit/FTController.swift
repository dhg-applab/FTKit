import ARKit

public class FTController: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var dataHandler: ((FTData) -> Void)?
    private var contentNode: SCNReferenceNode?
    public var sceneView: ARSCNView? {
        didSet {
            sceneView?.delegate = self
            sceneView?.session.delegate = self
        }
    }
    lazy var configuration: ARConfiguration? = {
        guard ARFaceTrackingConfiguration.isSupported else { return nil }
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        configuration.isLightEstimationEnabled = true
        return configuration
    }()
    
    override init() {
        sceneView = ARSCNView()
        super.init()
    }
}

extension FTController {
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }

        contentNode = SCNReferenceNode()
        return contentNode
    }

    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        let data = FTData(blendShapes: getBlendShapes(on: faceAnchor),
                          lightEstimate: getLightEstimate(),
                          depthmap: getDepthMap(),
                          lookAtPoint: getLookAtPoint(on: faceAnchor))
        self.dataHandler?(data)
    }

    private func getBlendShapes(on faceAnchor: ARFaceAnchor) -> [String: Double] {
        var blendShapes: [String: Double] = [:]
        blendShapes = faceAnchor.blendShapes.reduce(into: [:], { partialResult, blendShape in
            partialResult[blendShape.key.rawValue] = blendShape.value.doubleValue
        })
        if let timestamp = sceneView?.session.currentFrame?.timestamp {
            blendShapes["timestamp"] = timestamp
        }

        return blendShapes
    }

    private func getLightEstimate() -> [String: Double] {
        guard let lightEstimate = sceneView?.session.currentFrame?.lightEstimate else { return [:] }

        return [
            "ambientColorTemperature": Double(lightEstimate.ambientColorTemperature),
            "ambientIntensity": Double(lightEstimate.ambientIntensity)
        ]
    }

    private func getDepthMap() -> CVPixelBuffer? {
        sceneView?.session.currentFrame?.capturedDepthData?.depthDataMap
    }
    
    private func getLookAtPoint(on faceAnchor: ARFaceAnchor) -> [String: Double] {
        [
            "lookAtPoint.X": Double(faceAnchor.lookAtPoint.x),
            "lookAtPoint.Y": Double(faceAnchor.lookAtPoint.y),
            "lookAtPoint.Z": Double(faceAnchor.lookAtPoint.z),
        ]
    }
}

