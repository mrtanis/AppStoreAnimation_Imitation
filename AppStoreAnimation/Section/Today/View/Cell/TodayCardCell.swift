//
//  TodayCardCell.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/26.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

//动画总时间
private let animationTotalTime = 0.3
//手指最大移动距离
private let maxMoveDistance:CGFloat = 20.0

class TodayCardCell: UICollectionViewCell, Reusable {
    var touchClosure : ((_ cell:TodayCardCell) -> ())?
    
    //最初触摸点
    var beginPoint: CGPoint?
    //最初触摸时间
    var beginTime: Double?
    //缩放动画开始到被中断的时间间隔
    var animationTimeInterval = 0.5
    //恢复动画是否执行
    var restoreExcuted = false
    
    
    override func awakeFromNib() {
        //圆角
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        //阴影
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.6
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        if isInside {
            if let closure = touchClosure {
                closure(self)
            }
            
            beginPoint = point
            beginTime = CFAbsoluteTimeGetCurrent()
            shrink()
        }
        return isInside;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let point = touch?.location(in: self)
//        beginPoint = point
//        beginTime = CFAbsoluteTimeGetCurrent()
//        shrink()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        guard let point = touch?.location(in: self), let begin = beginPoint else {
            return
        }
        let distance = abs(point.y - begin.y)
        if distance > maxMoveDistance && restoreExcuted == false {
            restoreExcuted = true
            let nowTime = CFAbsoluteTimeGetCurrent()
            let timeDiff = nowTime - beginTime!
            animationTimeInterval = max(timeDiff, animationTotalTime)
            restore()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if restoreExcuted == false {
            let nowTime = CFAbsoluteTimeGetCurrent()
            let timeDiff = nowTime - beginTime!
            animationTimeInterval = max(timeDiff, animationTotalTime)
            restore()
        }
        restoreExcuted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if restoreExcuted == false {
            let nowTime = CFAbsoluteTimeGetCurrent()
            let timeDiff = nowTime - beginTime!
            animationTimeInterval = max(timeDiff, animationTotalTime)
            restore()
        }
        restoreExcuted = false
    }
    
    //缩小动画
    func shrink() {
        UIView.animate(withDuration: animationTotalTime, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    //还原动画
    func restore() {
        UIView.animate(withDuration: animationTimeInterval, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
