import CoreVideo
import ARKit

public struct FTData {
    public let blendShapes: [String: Double]
    public let lightEstimate: [String: Double]
    public let depthmap: CVPixelBuffer?
    public let lookAtPoint: [String: Double]
    public let faceGeometryVertices: [simd_float3]
}
