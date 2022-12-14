import CoreVideo

public struct FTData {
    public let blendShapes: [String: Double]
    public let lightEstimate: [String: Double]
    public let depthmap: CVPixelBuffer?
    public let lookAtPoint: [String: Double]
}
