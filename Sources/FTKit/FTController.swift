import ARKit

public class FTController: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var configuration: FTConfiguration!
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
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let currentFrame = sceneView?.session.currentFrame else { return }
        
        updateFaceGeometry(on: faceAnchor, with: node)
        
        
        let timestamp = getTimestamp(timestamp: currentFrame.timestamp)
        var blendShapes: [String : Double]? = nil
        var lightEstimate: [String: Double]? = nil
    //    public let depthmap: CVPixelBuffer?
        var distanceToScreen: Double? = nil
        var lookAtPoint: [String: Double]? = nil
        var faceGeometryVertices: [simd_float3]? = nil
        
        
        if configuration.captureBlendShapes {
            blendShapes = getBlendShapes(on: faceAnchor)
        }
        if configuration.enableLightEstimate {
            lightEstimate = getLightEstimate()
        }
//        if configuration.captureDepthMap {
//            depthmap = getDepthMap()
//        }
        if configuration.captureDistanceToScreen {
            distanceToScreen = getDistanceToScreen(on: faceAnchor)
        }
        if configuration.captureLookAtPoint {
            lookAtPoint = getLookAtPoint(on: faceAnchor)
        }
        if configuration.captureFaceVertices {
            if configuration.faceGeometryVerticesIndexs.isEmpty {
                faceGeometryVertices = faceAnchor.geometry.vertices
            } else {
                faceGeometryVertices = []
                for index in configuration.faceGeometryVerticesIndexs {
                    faceGeometryVertices!.append(faceAnchor.geometry.vertices[index])
                }
            }
        }
        
        let data = FTData(timestamp: timestamp,
                          blendShapes: blendShapes,
                          lightEstimate: lightEstimate,
                          distanceToScreen: distanceToScreen,
                          lookAtPoint: lookAtPoint,
                          faceGeometryVertices: faceGeometryVertices)
        self.configuration?.dataHandler?(data)
    }
    
    
    private func getTimestamp(timestamp: TimeInterval) -> Double {
        let refDate = Date() - ProcessInfo.processInfo.systemUptime
        return Date(timeInterval: timestamp, since: refDate).timeIntervalSince1970
    }

    
    private func getBlendShapes(on faceAnchor: ARFaceAnchor) -> [String: Double] {
        var blendShapes: [String: Double] = [:]
        blendShapes = faceAnchor.blendShapes.reduce(into: [:], { partialResult, blendShape in
            partialResult[blendShape.key.rawValue] = blendShape.value.doubleValue
        })
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
    
    private func getDistanceToScreen(on faceAnchor: ARFaceAnchor) -> Double {
        guard let frame = sceneView?.session.currentFrame else { return 0.0 }
        
        let deviceTransform = frame.camera.transform.columns.3
        let devicePosition = simd_float3(x: deviceTransform.x, y: deviceTransform.y, z: deviceTransform.z)
        
        // Translating position of the left eye from face to world coordinates
        let leftEyeWorldTransform = matrix_multiply(faceAnchor.transform, faceAnchor.leftEyeTransform).columns.3
        let leftEyePosition = simd_float3(x: leftEyeWorldTransform.x, y: leftEyeWorldTransform.y, z: leftEyeWorldTransform.z)
        
        // Translating position of the right eye from face to world coordinates
        let rightEyeWorldTransform = matrix_multiply(faceAnchor.transform, faceAnchor.rightEyeTransform).columns.3
        let rightEyePosition = simd_float3(x: rightEyeWorldTransform.x, y: rightEyeWorldTransform.y, z: rightEyeWorldTransform.z)
        
        // Getting the point in middle betweeen the eyes
        let eyesPostion = mix(leftEyePosition, rightEyePosition, t: 0.5)
 
        return Double(distance(devicePosition, eyesPostion))
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
