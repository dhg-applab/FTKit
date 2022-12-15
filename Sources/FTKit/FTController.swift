import ARKit

public class FTController: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    
    var configuration: FTConfiguration?
    public var sceneView: ARSCNView? {
        didSet {
            sceneView?.delegate = self
            sceneView?.session.delegate = self
        }
    }
    lazy var arConfiguration: ARConfiguration? = {
        guard ARFaceTrackingConfiguration.isSupported else { return nil }
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        configuration.isLightEstimationEnabled = true
        return configuration
    }()
    private var contentNode: SCNReferenceNode?
    
    override init() {
        sceneView = ARSCNView()
        super.init()
    }
}

extension FTController {
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }

//        contentNode = SCNReferenceNode()
//        return contentNode
        return addFaceGeometry()
    }

    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        updateFaceGeometry(on: faceAnchor, with: node)
        
        let data = FTData(blendShapes: getBlendShapes(on: faceAnchor),
                          lightEstimate: getLightEstimate(),
                          depthmap: getDepthMap(),
                          lookAtPoint: getLookAtPoint(on: faceAnchor),
                          faceGeometryVertices: faceAnchor.geometry.vertices)
        self.configuration?.dataHandler?(data)
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
    
    private func addFaceGeometry() -> SCNNode? {
        guard let device = sceneView?.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        
        for vertice in stride(from: 0, to: 1220, by: 2) {
            let text = SCNText(string: "\(vertice)", extrusionDepth: 1)
            let txtnode = SCNNode(geometry: text)
            txtnode.scale = SCNVector3(x: 0.0002, y: 0.0002, z: 0.0002)
            txtnode.name = "\(vertice)"
            node.addChildNode(txtnode)
            txtnode.geometry?.firstMaterial?.fillMode = .fill
        }
        
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    private func updateFaceGeometry(on faceAnchor: ARFaceAnchor, with node: SCNNode) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        for vertice in 0 ..< 1220 {
            let child = node.childNode(withName: "\(vertice)", recursively: false)
            child?.position = SCNVector3(faceAnchor.geometry.vertices[vertice])
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
