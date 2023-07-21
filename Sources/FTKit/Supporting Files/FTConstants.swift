import Foundation

public enum FTConstants {
    public enum FaceGeometry {
        public static let numberOfFaceGeometryVertices = 1220
        public static let edgeFaceGeometryVertices = [1076, 1070, 1163, 1168, 1094, 358, 1108, 1102, 20, 661, 888, 822, 1047, 462, 376, 39]
        public static let mouthTopLeftVertices = Array(250...256)
        public static let mouthTopCenterVertices = [24]
        public static let mouthTopRightVertices = Array(685...691).reversed()
        public static let mouthRightVertices = [684]
        public static let mouthBottomRightVertices = [682, 683, 700, 709, 710, 725]
        public static let mouthBottomCenterVertices = [25]
        public static let mouthBottomLeftVertices = [265, 274, 290, 275, 247, 248]
        public static let mouthLeftVertices = [249]
        public static let eyeTopLeftVertices = Array(1090...1101)
        public static let eyeBottomLeftVertices = Array(1102...1108) + Array(1085...1089)
        public static let eyeTopRightVertices = Array(1069...1080)
        public static let eyeBottomRightVertices = Array(1081...1084) + Array(1061...1068)
    }
}
