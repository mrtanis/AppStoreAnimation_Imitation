//
//  ExtendPresentAnimationController.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/29.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class ExtendPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let tabVC = fromVC as! TabVC
        let navVC = tabVC.selectedViewController as! NavVC
        let todayVC = navVC.viewControllers.first as! TodayVC
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let snapContainer = UIView()
        snapContainer.frame = originFrame
        snapContainer.layer.cornerRadius = 15
        snapContainer.layer.masksToBounds = true
        snapContainer.addSubview(snapshot)
        let width = finalFrame.width
        let height = finalFrame.height
        let x = -(finalFrame.width-originFrame.width)*0.5
        let y = -(finalFrame.height*0.5*0.1+finalFrame.width*0.5*1.2*0.9-originFrame.width*1.2*0.5)
        snapshot.frame = CGRect(x: x, y: y, width: width, height: height)
        snapshot.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        //添加两个标题
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapContainer)
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                snapContainer.frame = finalFrame
                snapContainer.layer.cornerRadius = 0
                snapshot.frame = finalFrame
//                snapshot.transform = CGAffineTransform.identity
            })
        }) { _ in
            todayVC.currentTouchCell?.transform = CGAffineTransform.identity
            toVC.view.isHidden = false
            snapContainer.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
