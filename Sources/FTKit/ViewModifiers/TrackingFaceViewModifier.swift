//
//  File.swift
//  
//
//  Created by Florian Schweizer on 07.08.23.
//

import SwiftUI
import ARKit

struct FaceTrackingViewModifier: ViewModifier {
    let configuration: FTConfiguration

    func body(content: Content) -> some View {
        content
            .onAppear {
                if let controller = UIApplication.topViewController() {
                    FTKit.shared.configuration = configuration
                    FTKit.shared.start(hiddenOnView: controller.view)
                }
            }
            .onDisappear {
                FTKit.shared.stop()
            }
    }
}

extension View {
    func trackingFace(
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
        captureFramesFilename: String? = nil,
        dataHandler: ((FTData) -> Void)?
    ) -> some View {
        modifier(FaceTrackingViewModifier(configuration: .init(
            dataHandler: dataHandler,
            arConfiguration: arConfiguration,
            runOptions: runOptions,
            showVerticiesInARView: showVerticiesInARView,
            enableLightEstimate: enableLightEstimate,
            captureBlendShapes: captureBlendShapes,
            captureLookAtPoint: captureLookAtPoint,
            captureDepthMap: captureDepthMap,
            captureDistanceToScreen: captureDistanceToScreen,
            captureFaceVertices: captureFaceVertices,
            faceGeometryVerticesIndexs: faceGeometryVerticesIndexs,
            faceGeometryVerticesEveryXIndex: faceGeometryVerticesEveryXIndex,
            captureFrames: captureFrames,
            captureFramesFolderURL: captureFramesFolderURL,
            captureFramesFilename: captureFramesFilename
        )))
    }
}
