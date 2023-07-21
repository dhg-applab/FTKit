import ARKit

public struct FTConfiguration {
    let dataHandler: ((FTData) -> Void)?
    let arConfiguration: ARConfiguration?
    let runOptions: ARSession.RunOptions?
    let showVerticiesInARView: Bool
    let enableLightEstimate: Bool
    let captureBlendShapes: Bool
    let captureLookAtPoint: Bool
    let captureDepthMap: Bool
    let captureDistanceToScreen: Bool
    let captureFaceVertices: Bool
    let faceGeometryVerticesIndexs: [Int]?
    let faceGeometryVerticesEveryXIndex: Int?
    let captureFrames: Bool
    let captureFramesFolderURL: URL?
    let captureFramesFilename: String?
    
    public init(dataHandler: ((FTData) -> Void)?,
                arConfiguration: ARConfiguration? = nil,
                runOptions: ARSession.RunOptions? = nil,
                showVerticiesInARView: Bool = false,
                enableLightEstimate: Bool = true,
                captureBlendShapes: Bool = true,
                captureLookAtPoint: Bool = true,
                captureDepthMap: Bool = true,
                captureDistanceToScreen: Bool = true,
                captureFaceVertices: Bool = true,
                faceGeometryVerticesIndexs: [Int]? = [],
                faceGeometryVerticesEveryXIndex: Int? = nil,
                captureFrames: Bool = false,
                captureFramesFolderURL: URL? = nil,
                captureFramesFilename: String? = nil) {
        self.dataHandler = dataHandler
        self.arConfiguration = arConfiguration
        self.runOptions = runOptions
        self.showVerticiesInARView = showVerticiesInARView
        
        self.enableLightEstimate = enableLightEstimate
        self.captureBlendShapes = captureBlendShapes
        self.captureLookAtPoint = captureLookAtPoint
        self.captureDepthMap = captureDepthMap
        self.captureDistanceToScreen = captureDistanceToScreen
        
        self.captureFaceVertices = captureFaceVertices
        self.faceGeometryVerticesIndexs = faceGeometryVerticesIndexs
        self.faceGeometryVerticesEveryXIndex = faceGeometryVerticesEveryXIndex
        
        self.captureFrames = captureFrames
        self.captureFramesFolderURL = captureFramesFolderURL
        self.captureFramesFilename = captureFramesFilename
        
        if captureFrames,
           captureFramesFolderURL == nil || captureFramesFilename == nil {
            assertionFailure("To capture frames, both `captureFramesFolderURL` and `captureFramesFilename` needs to be set.")
        }
    }
}
