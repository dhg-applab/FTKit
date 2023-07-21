import CoreVideo
import ARKit

public struct FTData: Codable {
    public let timestamp: Double
    public let blendShapes: [String: Double]?
    public let lightEstimate: [String: Double]?
//    public let depthmap: CVPixelBuffer?
    public let distanceToScreen: Double?
    public let lookAtPoint: [String: Double]?
    public let faceGeometryVertices: [simd_float3]?
    
    public static let csvHeader = "type,timestamp,blendshapes,lightestimate,distanceToScreen,lookAtPoint,faceGeometryVertices"
    
    public func toCsv() -> String {
        let blendshapeString = blendShapes?.toString() ?? "[]"
        let lightEstimateString = lightEstimate?.toString() ?? "[]"
        let distanceToScreenString = distanceToScreen.map { String($0) } ?? "nil"
        let lookAtPointString = lookAtPoint?.toString() ?? "[]"
        let faceGeometryVerticesString = "[" + (faceGeometryVertices?.map { $0.toString() }.joined(separator: " ") ?? "[]") + "]"
        
        return "facetracking,\(timestamp),\(blendshapeString),\(lightEstimateString),\(distanceToScreenString),\(lookAtPointString),\(faceGeometryVerticesString)"
    }
}


fileprivate extension Dictionary where Key == String, Value == Double {
    func toString() -> String {
        "[" + self.map { "\($0.key):\($0.value)" }.joined(separator: " ") + "]"
    }
}

fileprivate extension simd_float3 {
    func toString() -> String {
        "[\(self.x) \(self.y) \(self.z)]"
    }
}
