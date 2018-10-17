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
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let tVC = transitionContext.viewController(forKey: .to),
            let snapshot = tVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let tabVC = fromVC as! TabVC
        let navVC = tabVC.selectedViewController as! NavVC
        let todayVC = navVC.viewControllers.first as! TodayVC
        let toVC = tVC as! TodayCardDetailVC
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        //添加blurView
        let effect = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView.init(effect: effect)
        blurView.alpha = 0
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        
        
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
        //先添加透明视图（大小同详情页顶部图片视图大小）
        let clearBG = UIView()
        clearBG.backgroundColor = .clear
        snapContainer.addSubview(clearBG)
        let cleanBGW = ScreenWidth-40
        let cleanBGH = cleanBGW * 1.2
        let cleanBGX = -(cleanBGW-originFrame.width)*0.5
        let cleanBGY = -(cleanBGH-originFrame.width*1.2)*0.5
        
        clearBG.frame = CGRect(x: cleanBGX, y: cleanBGY, width: cleanBGW, height: cleanBGH)
        
        let title1 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            $0.text = "生活解决方案"
        }
        clearBG.addSubview(title1)
        title1.sizeToFit()
        title1.frame = CGRect(x:  15, y:  12, width: ScreenWidth-30, height: title1.bounds.height)
        
        let title2 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
            $0.textColor = .white
            $0.text = "帮你找份理想工作"
        }
        clearBG.addSubview(title2)
        title2.sizeToFit()
        title2.frame = CGRect(x:   12, y:  title1.frame.maxY+6, width: ScreenWidth-30, height: title2.bounds.height)

        
        clearBG.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapContainer)
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                blurView.alpha = 1
                snapContainer.frame = CGRect(x: 0, y: -5, width: finalFrame.width, height: finalFrame.height)
                snapContainer.layer.cornerRadius = 0
                clearBG.transform = CGAffineTransform.identity
                title1.frame = CGRect(x: 15, y: 15, width: ScreenWidth-30, height: title1.bounds.height)
                title2.frame = CGRect(x: 12, y: title1.frame.maxY + 6, width: ScreenWidth-30, height: title2.bounds.height)
                clearBG.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: finalFrame.width*1.2)
                snapshot.frame = finalFrame
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                snapContainer.frame = CGRect(x: 0, y: 3, width: finalFrame.width, height: finalFrame.height)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                snapContainer.frame = finalFrame
            })
        }) { _ in
            todayVC.currentTouchCell?.transform = CGAffineTransform.identity
            toVC.view.isHidden = false
            toVC.title1.isHidden = false
            toVC.title2.isHidden = false
            blurView.removeFromSuperview()
            snapContainer.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
