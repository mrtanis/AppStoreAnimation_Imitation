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
    @objc func SwipeInteractionAskToShowStatusBar()
}

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    //代理
    weak var delegate: SwipeInteractionDelegate?
    var beginPoint = CGPoint.zero
    var beginTransition = CGPoint.zero
    var delegateCalled = false
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: TodayCardDetailVC!
    
    init(viewController: TodayCardDetailVC) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        //侧滑返回
        let sideSwipe = UIScreenEdgePanGestureRecognizer(target: self,
                                                       action: #selector(handleSideSwipeGesture(_:)))
        sideSwipe.edges = .left
        view.addGestureRecognizer(sideSwipe)
        
        //下滑返回
        let downSwipe = UIPanGestureRecognizer(target: self, action: #selector(handleDownSwipeGesture(_:)))

        downSwipe.require(toFail: sideSwipe)
        view.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleSideSwipeGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
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
            shouldCompleteTransition = progress > 0.41
            if shouldCompleteTransition {
                if delegateCalled == false, let delegeteOK = delegate, delegeteOK.responds(to: #selector(SwipeInteractionDelegate.SwipeInteractionAskToShowStatusBar)) {
                    delegateCalled = true
                    delegeteOK.SwipeInteractionAskToShowStatusBar()
                }
                finish()
                print(">>>Side<<<Dissmiss Transition Finished!")
            } else {
                update(progress)
            }
            
            
        // 4
        case .cancelled:
            interactionInProgress = false
            cancel()
            print(">>>Side<<<Dissmiss Transition Cancelled!")
            
        // 5
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
                print(">>>Side<<<Dissmiss Transition Finished!")
            } else {
                cancel()
                print(">>>Side<<<Dissmiss Transition Cancelled!")
            }
        default:
            break
        }
    }
    
    @objc func handleDownSwipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        
        
        let currentPoint = gestureRecognizer.location(in: gestureRecognizer.view!.superview!)
        
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = ((translation.y - beginTransition.y) / 300)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {
            
        // 2
        case .began:
            beginPoint = currentPoint

        // 3
        case .changed:
            if !interactionInProgress {
                beginTransition = translation
            }
            
            if currentPoint.y <= beginPoint.y || viewController.scrollView.contentOffset.y > 0{
                return
            }

            if !interactionInProgress {
                interactionInProgress = true
                viewController.dismiss(animated: true, completion: nil)
            }
            
            
            shouldCompleteTransition = progress > 0.41
            if shouldCompleteTransition {
                if delegateCalled == false, let delegeteOK = delegate, delegeteOK.responds(to: #selector(SwipeInteractionDelegate.SwipeInteractionAskToShowStatusBar)) {
                    delegateCalled = true
                    delegeteOK.SwipeInteractionAskToShowStatusBar()
                }
                finish()
                print(">>>Down<<<Dissmiss Transition Finished!")
            } else {
                update(progress)
            }
            
            
        // 4
        case .cancelled:
            
            cancel()
           interactionInProgress = false
            print(">>>Down<<<Dissmiss Transition Cancelled!")
            
        // 5
        case .ended:
            
            if shouldCompleteTransition {
                finish()
                print(">>>Down<<<Dissmiss Transition Finished!")
            } else {
                cancel()
                print(">>>Down<<<Dissmiss Transition Cancelled!")
            }
            interactionInProgress = false
        default:
            break
        }
    }
}
