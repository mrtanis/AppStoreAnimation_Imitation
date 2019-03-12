//
//  TodayCardCell.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/26.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

//动画总时间
private let animationTotalTime = 0.2
//手指最大移动距离
private let maxMoveDistance:CGFloat = 20.0

//代理
 @objc protocol TodayCardCellDelegate: NSObjectProtocol {
    @objc func jumpToCardDetail(fromCell cell:TodayCardCell)
    @objc func updateBeginTouchFrame(cellFrame rect:CGRect, ofCell cell:TodayCardCell)
}

enum shrinkState {
    case shrinking
    case shrinked
}

enum restoreState {
    case restoring
    case restored
}

enum animationState {
    case normal
    case shrinking
    case shrinked
    case restoring
    case restored
}

enum touchState: Int {
    case none
    case touchBegan
    case touchMoved
    case touchEnded
}

class TodayCardCell: UICollectionViewCell, Reusable, UIGestureRecognizerDelegate{
    var touchClosure : ((_ cell:TodayCardCell) -> ())?
    //代理
    weak var delegate: TodayCardCellDelegate?
    //最初触摸点
    var beginPoint: CGPoint?
    //最初触摸时间
    var beginTime: Double?
    //缩放动画开始到被中断的时间间隔
    var animationTimeInterval = 0.5
    //动画状态
    var nowState = animationState.normal
    //触摸状态
    var nowTouchState = touchState.none
    //恢复动画是否执行
    var restoreExcuted = false {
        didSet {
            print("恢复动画bool值被设置\(restoreExcuted)")
        }
    }
    //缩小动画是或否执行完毕
    var shrinkFinished = false
    //手指是否在cell上
    var isFingerOn = false
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    //图片视图宽度
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        //设置图片视图宽度
        imageViewWidth.constant = ScreenWidth
        
        //圆角
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        //阴影
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKind(of: UIScrollView.self)) {
            return false;
        }
        else {
            return true;
        }
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = super.point(inside: point, with: event)
        if isInside {
            print("pointInside")
            if let delegeteOK = delegate, delegeteOK.responds(to: #selector(TodayCardCellDelegate.updateBeginTouchFrame(cellFrame:ofCell:))) {
                delegeteOK.updateBeginTouchFrame(cellFrame: self.frame, ofCell: self)
            }
            
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
        print("TouchesBegan")
        nowTouchState = .touchBegan
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchesMoved")
        nowTouchState = .touchMoved
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchEnded")
        nowTouchState = .touchEnded
        if let delegeteOK = delegate, delegeteOK.responds(to: #selector(TodayCardCellDelegate.jumpToCardDetail(fromCell:))), nowState == animationState.shrinked {

            delegeteOK.jumpToCardDetail(fromCell: self)
        }

        isFingerOn = false
        restoreExcuted = false
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TouchEnded")

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
        nowState = .shrinking
        print("缩小")
        self.shrinkFinished = false
        UIView.animate(withDuration: animationTotalTime, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { (finished) in
            self.nowState = .shrinked
            self.shrinkFinished = true
            if let delegeteOK = self.delegate, delegeteOK.responds(to: #selector(TodayCardCellDelegate.jumpToCardDetail(fromCell:))), self.nowTouchState == .touchEnded {

                delegeteOK.jumpToCardDetail(fromCell: self)
            }
        })
    }
    
    //还原动画
    func restore() {
        if self.transform == CGAffineTransform.identity { return }
        nowState = .restoring
        print("还原")
        UIView.animate(withDuration: max(animationTimeInterval,0.2), delay: 0, options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished) in
            self.nowState = .restored
        })
    }
}

