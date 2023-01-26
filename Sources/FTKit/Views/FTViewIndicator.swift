import ARKit
import SwiftUI

public struct FTViewIndicator: UIViewControllerRepresentable {
    var controller: FTViewController
    var dataHandler: ((FTData) -> Void)?
    
    public func makeUIViewController(context: Context) -> FTViewController {
        controller
    }
    
    public func updateUIViewController(_ uiViewController: FTViewController, context: Context) { }
}
