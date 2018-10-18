//
//  ShrinkDismissAnimationController.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/10/17.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class ShrinkDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let finalFrame: CGRect
    
    init(finalFrame: CGRect) {
        self.finalFrame = finalFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let tVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        //添加将要呈现的VC视图
        containerView.addSubview(tVC.view)
        //添加模糊视图
        let effect = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView.init(effect: effect)
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        //添加当前VC的snapshot
        containerView.addSubview(snapshot)
        //制作当前VC头部图片视图和标题
        let snapContainer = UIView()
        snapContainer.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*1.2)
        snapContainer.layer.masksToBounds = true
        
        //开始做动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                snapshot.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0, animations: {
                blurView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                snapshot.frame = self.finalFrame
            })
        }) { (finished) in
            blurView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        
        
    }
    

}
