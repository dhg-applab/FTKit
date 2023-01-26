//
//  FTConfiguration.swift
//  
//
//  Created by Leon Nissen on 25.01.23.
//

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
    let faceGeometryVerticesIndexs: [Int]
    
    public init(dataHandler: ((FTData) -> Void)?,
                arConfiguration: ARConfiguration? = nil,
                runOptions: ARSession.RunOptions? = nil,
                enableLightEstimate: Bool = true,
                captureBlendShapes: Bool = true,
                captureLookAtPoint: Bool = true,
                captureDepthMap: Bool = true,
                captureFaceVertices: Bool = true,
                faceGeometryVerticesIndexs: [Int] = []) {
        self.dataHandler = dataHandler
        self.arConfiguration = arConfiguration
        self.runOptions = runOptions
        self.enableLightEstimate = enableLightEstimate
        self.captureBlendShapes = captureBlendShapes
        self.captureLookAtPoint = captureLookAtPoint
        self.captureDepthMap = captureDepthMap
        self.captureFaceVertices = captureFaceVertices
        self.faceGeometryVerticesIndexs = faceGeometryVerticesIndexs
    }
}
