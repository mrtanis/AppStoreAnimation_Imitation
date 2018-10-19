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
    
    let interactionController: SwipeInteractionController?
    
    init(finalFrame: CGRect, interactionController: SwipeInteractionController?) {
        self.finalFrame = finalFrame
        self.interactionController = interactionController
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
        snapshot.frame = containerView.bounds
        snapshot.layer.masksToBounds = true
        //制作当前VC头部图片视图和标题
        let snapContainer = UIView()
        snapContainer.backgroundColor = .clear
        snapContainer.layer.masksToBounds = true
        //添加图片视图
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "iOSDevelopLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*1.2)
        snapContainer.addSubview(imageView)
        //添加两个标题
        let title1 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            $0.text = "生活解决方案"
        }
        snapContainer.addSubview(title1)
        title1.sizeToFit()
        title1.frame = CGRect(x:  15, y:  12, width: ScreenWidth-30, height: title1.bounds.height)
        
        let title2 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
            $0.textColor = .white
            $0.text = "帮你找份理想工作"
        }
        snapContainer.addSubview(title2)
        title2.sizeToFit()
        title2.frame = CGRect(x:   12, y:  title1.frame.maxY+6, width: ScreenWidth-30, height: title2.bounds.height)
        
        containerView.addSubview(snapContainer)
        snapContainer.frame = containerView.bounds
        
        //开始做动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                snapContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                snapshot.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                snapshot.layer.cornerRadius = 13
                snapContainer.layer.cornerRadius = 13
                imageView.layer.cornerRadius = 13
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0, animations: {
                blurView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                snapshot.transform = CGAffineTransform.identity
                snapshot.frame = self.finalFrame
                snapshot.layer.cornerRadius = 15
                snapContainer.transform = CGAffineTransform.identity
                snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                snapContainer.bounds = CGRect(x: 0, y: 0, width: self.finalFrame.width, height: self.finalFrame.height)
                snapContainer.layer.cornerRadius = 15
                imageView.frame = CGRect(x: -20, y: -20*1.2, width: ScreenWidth, height: ScreenWidth*1.2)
                imageView.layer.cornerRadius = 15
            })
        }) { (finished) in
            blurView.removeFromSuperview()
            snapshot.removeFromSuperview()
            snapContainer.removeFromSuperview()
            let success = !transitionContext.transitionWasCancelled
            if !success {
                tVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        
        
        
    }
    

}
