import UIKit
import ARKit

public class FTViewController: UIViewController {
    var controller: FTController?
    
    public override func loadView() {
        super.loadView()
        controller?.sceneView = ARSCNView(frame: .zero)
        self.view = controller?.sceneView
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        controller?.sceneView?.session.pause()
    }
}
