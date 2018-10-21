//
//  SwipeInteractionController.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/10/19.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

//代理
@objc protocol SwipeInteractionDelegate: NSObjectProtocol {
    @objc func SwipeInteractionAskToShowTabBar()
}

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    //代理
    weak var delegate: SwipeInteractionDelegate?
    
    var delegateCalled = false
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                       action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        // 2
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        // 3
        case .changed:
            shouldCompleteTransition = progress > 0.5
            if shouldCompleteTransition {
                if delegateCalled == false, let delegeteOK = delegate, delegeteOK.responds(to: #selector(SwipeInteractionDelegate.SwipeInteractionAskToShowTabBar)) {
                    delegateCalled = true
                    delegeteOK.SwipeInteractionAskToShowTabBar()
                }
                finish()
            }
            update(progress)
            
        // 4
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        // 5
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
