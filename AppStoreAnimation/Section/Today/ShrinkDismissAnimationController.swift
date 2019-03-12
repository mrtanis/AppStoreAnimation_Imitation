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
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayCardDetailVC,
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshotFromVC = fromVC.view.snapshotView(afterScreenUpdates: false),
        let snapshotImage = fromVC.headerImage.snapshotView(afterScreenUpdates: false),
        let snapshotTitle1 = fromVC.title1.snapshotView(afterScreenUpdates: false),
        let snapshotTitle2 = fromVC.title2.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let tabVC = toVC as! TabVC
        let navVC = tabVC.selectedViewController as! NavVC
        let todayVC = navVC.viewControllers.first as! TodayVC
        
        //将tabBar显示，取snapshot
        tabVC.tabBar.isHidden = false
        guard let snapshotTabBar = tabVC.tabBar.snapshotView(afterScreenUpdates: true) else {
            return
        }
        //取完snapshot再将TabBar隐藏
        tabVC.tabBar.isHidden = true
        
        let containerView = transitionContext.containerView
        
        //添加将要呈现的VC视图
        containerView.addSubview(toVC.view)
        
        //添加模糊视图
        let effect = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView.init(effect: effect)
        if (fluentAnimation) {
            blurView.alpha = 0
        }
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        
        //反向跳转时，containerView默认包含ToVC的View，所以要手动添加FromVC的snapshot(不需要添加View，因为它本来就是要被推出栈的)
        containerView.addSubview(snapshotFromVC)
        snapshotFromVC.frame = containerView.bounds
        snapshotFromVC.layer.masksToBounds = true
        
        //制作当前VC头部图片视图和标题
        let snapContainer = UIView()
        snapContainer.backgroundColor = .clear
        snapContainer.layer.masksToBounds = true
        
        //获取当前滚动偏移量
        let offsetY = fromVC.scrollView.contentOffset.y
        
        //添加图片视图
        snapshotImage.frame = CGRect(x: 0, y: -offsetY, width: ScreenWidth, height: ScreenWidth*1.2)
        snapContainer.addSubview(snapshotImage)
        
        //添加两个标题
        snapContainer.addSubview(snapshotTitle1)
        snapshotTitle1.frame = CGRect(x:  15, y:  15-offsetY, width: snapshotTitle1.bounds.width, height: snapshotTitle1.bounds.height)

        snapContainer.addSubview(snapshotTitle2)
        snapshotTitle2.frame = CGRect(x:  12, y:  snapshotTitle1.frame.maxY+6, width: snapshotTitle2.bounds.width, height: snapshotTitle2.bounds.height)
        
        containerView.addSubview(snapContainer)
        snapContainer.frame = containerView.bounds
        
        containerView.addSubview(snapshotTabBar)
        snapshotTabBar.frame = CGRect(x: 0, y: containerView.bounds.height, width: snapshotTabBar.bounds.width, height: snapshotTabBar.bounds.height)
        
        //开始做动画
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            if (self.fluentAnimation) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    snapshotFromVC.frame = self.finalFrame.offsetBy(dx: 0, dy: 10)
                    snapshotFromVC.layer.cornerRadius = 15
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY + 10)
                    snapContainer.bounds = CGRect(x: 0, y: 10, width: self.finalFrame.width, height: self.finalFrame.height)
                    snapContainer.layer.cornerRadius = 15
                    snapshotTitle1.frame = CGRect(x:  15, y:  12, width: snapshotTitle1.bounds.width, height: snapshotTitle1.bounds.height)
                    snapshotTitle2.frame = CGRect(x:   12, y:  snapshotTitle1.frame.maxY+6, width: snapshotTitle2.bounds.width, height: snapshotTitle2.bounds.height)
                    snapshotImage.frame = CGRect(x: -20, y: -20*1.2, width: ScreenWidth, height: ScreenWidth*1.2)
                    snapshotImage.layer.cornerRadius = 15
                    snapshotTabBar.frame = CGRect(x: 0, y: containerView.bounds.height - snapshotTabBar.bounds.height, width: snapshotTabBar.bounds.width, height: snapshotTabBar.bounds.height)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    snapshotFromVC.frame = self.finalFrame
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                    snapContainer.bounds = CGRect(x: 0, y: 0, width: self.finalFrame.width, height: self.finalFrame.height)
                })
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                    snapContainer.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    snapshotFromVC.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    snapshotFromVC.layer.cornerRadius = 13
                    snapContainer.layer.cornerRadius = 13
                    snapshotImage.layer.cornerRadius = 13
                })
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.01, animations: {
                    blurView.alpha = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 0.41, relativeDuration: 0.39, animations: {
                    snapshotFromVC.transform = CGAffineTransform.identity
                    snapshotFromVC.frame = self.finalFrame.offsetBy(dx: 0, dy: 5)
                    snapshotFromVC.layer.cornerRadius = 15
                    snapContainer.transform = CGAffineTransform.identity
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY+5)
                    snapContainer.bounds = CGRect(x: 0, y: 5, width: self.finalFrame.width, height: self.finalFrame.height)
                    snapContainer.layer.cornerRadius = 15
                    snapshotTitle1.frame = CGRect(x:  15, y:  12, width: snapshotTitle1.bounds.width, height: snapshotTitle1.bounds.height)
                    snapshotTitle2.frame = CGRect(x:   12, y:  snapshotTitle1.frame.maxY+6, width: snapshotTitle2.bounds.width, height: snapshotTitle2.bounds.height)
                    snapshotImage.frame = CGRect(x: -20, y: -20*1.2, width: ScreenWidth, height: ScreenWidth*1.2)
                    snapshotImage.layer.cornerRadius = 15
                    snapshotTabBar.frame = CGRect(x: 0, y: containerView.bounds.height - snapshotTabBar.bounds.height, width: snapshotTabBar.bounds.width, height: snapshotTabBar.bounds.height)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                    snapshotFromVC.frame = self.finalFrame
                    snapContainer.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
                    snapContainer.bounds = CGRect(x: 0, y: 0, width: self.finalFrame.width, height: self.finalFrame.height)
                })
            }
            
        }) { (finished) in
            tabVC.tabBar.isHidden = false
            snapshotTabBar.removeFromSuperview()
            //移除模糊视图
            blurView.removeFromSuperview()
            //移除snapContainer
            snapContainer.removeFromSuperview()
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toVC.view.removeFromSuperview()
            } else {
                todayVC.currentTouchCell?.transform = CGAffineTransform.identity
                todayVC.currentTouchCell?.nowTouchState = .none
                todayVC.currentTouchCell?.nowState = .normal
            }
            transitionContext.completeTransition(success)
        }
        
        
        
    }
    

}
