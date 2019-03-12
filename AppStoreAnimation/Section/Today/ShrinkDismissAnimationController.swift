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
    var fluentAnimation: Bool
    
    let interactionController: SwipeInteractionController?
    
    init(finalFrame: CGRect, interactionController: SwipeInteractionController?, fluentAnimation: Bool) {
        self.finalFrame = finalFrame
        self.interactionController = interactionController
        self.fluentAnimation = fluentAnimation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (fluentAnimation) {
            return 0.8
        }
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let tVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let tabVC = tVC as! TabVC
        let navVC = tabVC.selectedViewController as! NavVC
        let todayVC = navVC.viewControllers.first as! TodayVC
        
        let containerView = transitionContext.containerView
        //添加将要呈现的VC视图
        containerView.addSubview(tVC.view)
        //添加模糊视图
        let effect = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView.init(effect: effect)
        if (fluentAnimation) {
            blurView.alpha = 0
        }
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
            $0.text = "出游专题"
        }
        snapContainer.addSubview(title1)
        title1.sizeToFit()
        title1.frame = CGRect(x:  15, y:  15, width: ScreenWidth-30, height: title1.bounds.height)
        
        let title2 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
            $0.textColor = .white
            $0.text = "与家人一起旅行"
        }
        snapContainer.addSubview(title2)
        title2.sizeToFit()
        title2.frame = CGRect(x:   12, y:  title1.frame.maxY+6, width: ScreenWidth-30, height: title2.bounds.height)
        
        containerView.addSubview(snapContainer)
        snapContainer.frame = containerView.bounds
        
        //开始做动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            if (self.fluentAnimation) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    snapshot.frame = self.finalFrame.offsetBy(dx: 0, dy: 10)
                    snapshot.layer.cornerRadius = 15
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY + 10)
                    snapContainer.bounds = CGRect(x: 0, y: 10, width: self.finalFrame.width, height: self.finalFrame.height)
                    snapContainer.layer.cornerRadius = 15
                    title1.frame = CGRect(x:  15, y:  12, width: ScreenWidth-30, height: title1.bounds.height)
                    title2.frame = CGRect(x:   12, y:  title1.frame.maxY+6, width: ScreenWidth-30, height: title2.bounds.height)
                    imageView.frame = CGRect(x: -20, y: -20*1.2, width: ScreenWidth, height: ScreenWidth*1.2)
                    imageView.layer.cornerRadius = 15
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    snapshot.frame = self.finalFrame
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                    snapContainer.bounds = CGRect(x: 0, y: 0, width: self.finalFrame.width, height: self.finalFrame.height)
                })
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    snapContainer.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    snapshot.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    snapshot.layer.cornerRadius = 13
                    snapContainer.layer.cornerRadius = 13
                    imageView.layer.cornerRadius = 13
                })
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.01, animations: {
                    blurView.alpha = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.41, relativeDuration: 0.39, animations: {
                    snapshot.transform = CGAffineTransform.identity
                    snapshot.frame = self.finalFrame.offsetBy(dx: 0, dy: 5)
                    snapshot.layer.cornerRadius = 15
                    snapContainer.transform = CGAffineTransform.identity
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY+5)
                    snapContainer.bounds = CGRect(x: 0, y: 5, width: self.finalFrame.width, height: self.finalFrame.height)
                    snapContainer.layer.cornerRadius = 15
                    title1.frame = CGRect(x:  15, y:  12, width: ScreenWidth-30, height: title1.bounds.height)
                    title2.frame = CGRect(x:   12, y:  title1.frame.maxY+6, width: ScreenWidth-30, height: title2.bounds.height)
                    imageView.frame = CGRect(x: -20, y: -20*1.2, width: ScreenWidth, height: ScreenWidth*1.2)
                    imageView.layer.cornerRadius = 15
                })
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                    snapshot.frame = self.finalFrame
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                    snapContainer.bounds = CGRect(x: 0, y: 0, width: self.finalFrame.width, height: self.finalFrame.height)
                })
            }
            
        }) { (finished) in
            blurView.removeFromSuperview()
            snapshot.removeFromSuperview()
            snapContainer.removeFromSuperview()
            let success = !transitionContext.transitionWasCancelled
            if !success {
                tVC.view.removeFromSuperview()
            } else {
                todayVC.currentTouchCell?.transform = CGAffineTransform.identity
                todayVC.currentTouchCell?.nowTouchState = .none
                todayVC.currentTouchCell?.nowState = .normal
            }
            transitionContext.completeTransition(success)
        }
        
        
        
    }
    

}
