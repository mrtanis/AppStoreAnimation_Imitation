//
//  ExtendPresentAnimationController.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/29.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit
import SnapKit

class ExtendPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    //cell缩放0.95倍后的frame（相对于整个View的frame）
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let tVC = transitionContext.viewController(forKey: .to)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let tabVC = fromVC as! TabVC
        let navVC = tabVC.selectedViewController as! NavVC
        let todayVC = navVC.viewControllers.first as! TodayVC
        let toVC = tVC as! TodayCardDetailVC
        
        //取标题、按钮以及tabbar的snapshot
        guard
            let snapshotTitle1 = toVC.title1.snapshotView(afterScreenUpdates: true),
            let snapshotTitle2 = toVC.title2.snapshotView(afterScreenUpdates: true),
            let snapshotClose = toVC.closeBtn.snapshotView(afterScreenUpdates: true),
        let snapshotTabBar = tabVC.tabBar.snapshotView(afterScreenUpdates: false)
        else {
            transitionContext.completeTransition(false)
                return
        }
        
        //隐藏真的TabBar
        tabVC.tabBar.isHidden = true
        
        //先把toVC的标题和按钮隐藏后，再取整个视图的snapshot
        toVC.title1.isHidden = true
        toVC.title2.isHidden = true
        toVC.closeBtn.isHidden = true
        
        guard let snapshotToVC = tVC.view.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
                return
        }
        
        //正向跳转时，containerView默认包含FromVC的View，不包含ToVC的View（因为FromVC已经在栈里）
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        //添加blurView（模糊FromVC的View）
        let effect = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView.init(effect: effect)
        blurView.alpha = 0
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        
        //创建snapContainer，用作需要动画的视图的容器
        //容器的作用是保证在放大动画过程中，视图的移动正确路径
        let snapContainer = UIView()
        //初始大小当然是和cell的大小相同
        snapContainer.frame = originFrame
        //圆角也要保持一致
        snapContainer.layer.cornerRadius = 15
        //保证子视图不超出显示范围
        snapContainer.layer.masksToBounds = true
        
        //添加ToVC的snapshot
        snapContainer.addSubview(snapshotToVC)
        let originWidth = originFrame.width
        let originHeight = originFrame.height
        let finalWidth = finalFrame.width
        let finalHeight = finalFrame.height
        let finalHeaderHeight = finalWidth * 1.2
        
        //此处计算需要画个图来解释
        let x = -(finalWidth-originWidth)*0.5
        let y = -(finalHeight*0.5*0.05+finalHeaderHeight*0.5*0.95-originHeight*0.5)
        snapshotToVC.frame = CGRect(x: x, y: y, width: finalWidth, height: finalHeight)
        //先缩放为0.95倍（因为此时的cell也是缩放0.95倍的）
        snapshotToVC.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        //添加两个标题
        //先添加透明视图（大小同cell未缩放的大小）
        let clearBG = UIView().then {
            $0.backgroundColor = .clear
            let cleanBGW = ScreenWidth-40
            let cleanBGH = cleanBGW * 1.2
            let cleanBGX = -(cleanBGW-originFrame.width)*0.5
            let cleanBGY = -(cleanBGH-originFrame.width*1.2)*0.5
            $0.frame = CGRect(x: cleanBGX, y: cleanBGY, width: cleanBGW, height: cleanBGH)
        }
        
        snapContainer.addSubview(clearBG)
        
        clearBG.addSubview(snapshotTitle1)
        snapshotTitle1.frame = CGRect(x:  15, y:  12, width: snapshotTitle1.bounds.width, height: snapshotTitle1.bounds.height)
        
        clearBG.addSubview(snapshotTitle2)
        snapshotTitle2.frame = CGRect(x:   12, y:  snapshotTitle1.frame.maxY+6, width: snapshotTitle2.bounds.width, height: snapshotTitle2.bounds.height)

        //创建关闭按钮
        clearBG.addSubview(snapshotClose)
        snapshotClose.frame = CGRect(x:  clearBG.bounds.width-15-25, y:  15, width: 25, height: 25)
        
        //缩放0.95倍
        clearBG.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        //添加ToVC的View到containerView，并隐藏
        containerView.addSubview(toVC.view)
        toVC.view.isHidden = true
        
        //添加snapContainer到containerView
        containerView.addSubview(snapContainer)
        
        //添加snapshotTabBar到containerView
        snapshotTabBar.frame = CGRect(x: 0, y: containerView.bounds.height - snapshotTabBar.bounds.height, width: snapshotTabBar.bounds.width, height: snapshotTabBar.bounds.height)
        containerView.addSubview(snapshotTabBar)
        
        
        //开始动画前隐藏cell
        todayVC.currentTouchCell?.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
      
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.35, animations: {
                blurView.alpha = 0.5
                snapContainer.frame = CGRect(x: 0, y: -5, width: finalFrame.width, height: finalFrame.height)
                snapContainer.layer.cornerRadius = 0
                clearBG.transform = CGAffineTransform.identity
                snapshotTitle1.frame = CGRect(x: 15, y: 15, width: snapshotTitle1.bounds.width, height: snapshotTitle1.bounds.height)
                snapshotTitle2.frame = CGRect(x: 12, y: snapshotTitle1.frame.maxY + 6, width: snapshotTitle2.bounds.width, height: snapshotTitle2.bounds.height)
                snapshotClose.frame = CGRect(x:  finalFrame.width-15-25, y:  15, width: 25, height: 25)
                clearBG.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: finalFrame.width*1.2)
                snapshotToVC.frame = finalFrame
                snapshotTabBar.frame = CGRect(x: 0, y: containerView.bounds.height, width: snapshotTabBar.bounds.width, height: snapshotTabBar.bounds.height)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                snapContainer.frame = CGRect(x: 0, y: 3, width: finalFrame.width, height: finalFrame.height)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                snapContainer.frame = finalFrame
            })
        }) { _ in
            //移除snapshotTabBar
            snapshotTabBar.removeFromSuperview()
            //移除blurView
            blurView.removeFromSuperview()
            //移除snapContainer
            snapContainer.removeFromSuperview()
            let success = !transitionContext.transitionWasCancelled
            if success {
                //完成后隐藏FromVC的状态栏
                todayVC.setStatusBar(forHidden: true, forStyle: .default, forAnimation: .none)
                todayVC.currentTouchCellOriginFrame = nil
                toVC.view.isHidden = false
                toVC.title1.isHidden = false
                toVC.title2.isHidden = false
                toVC.closeBtn.isHidden = false
            } else {
                todayVC.currentTouchCell?.isHidden = false
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
