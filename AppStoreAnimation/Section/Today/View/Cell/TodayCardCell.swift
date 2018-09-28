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
    var restoreExcuted = false {
        didSet {
            print("恢复动画bool值被设置\(restoreExcuted)")
        }
    }
    //手指是否在cell上
    var isFingerOn = false
    
    
    override func awakeFromNib() {
        //圆角
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        //阴影
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.4
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
            
            isFingerOn = true
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
            calculateTimeInterval()
            restore()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchEnded")
        calculateTimeInterval()
        restore()
        isFingerOn = false
        restoreExcuted = false
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchEnded")
        calculateTimeInterval()
        restore()
        isFingerOn = false
        restoreExcuted = false
    }
    
    //计算时间
    func calculateTimeInterval() {
        let nowTime = CFAbsoluteTimeGetCurrent()
        let timeDiff = nowTime - beginTime!
        animationTimeInterval = min(timeDiff, animationTotalTime)
    }
    
    //缩小动画
    func shrink() {
        if self.transform != CGAffineTransform.identity { return }
        print("缩小")
        UIView.animate(withDuration: animationTotalTime, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    //还原动画
    func restore() {
        if self.transform == CGAffineTransform.identity { return }
        print("还原")
        UIView.animate(withDuration: max(animationTimeInterval,0.2), delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}

