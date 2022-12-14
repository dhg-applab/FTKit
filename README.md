# FTKit

A package to enable face tracking by using Apple's [ARKit](https://developer.apple.com/documentation/arkit).

This package exposes the [`blendShapes`](https://developer.apple.com/documentation/arkit/arfaceanchor/2928251-blendshapes/), [`lookAtPoint`](https://developer.apple.com/documentation/arkit/arfaceanchor/2968192-lookatpoint), [`lightEstimate`](https://developer.apple.com/documentation/arkit/arlightestimate), and [`depthmap`](https://developer.apple.com/documentation/arkit/ardepthdata/3566296-depthmap).

Starting the face tracking can be done either by using the UIKit/SwiftUI view and run `FTKit.shared.start()` or hidden on a host view (most top view controller) by running `FTKit.shared.start(hiddenOnView:)`. 



## TopViewController Extension

```
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
```

