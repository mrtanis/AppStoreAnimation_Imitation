//
//  TodayCardDetailVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/29.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayCardDetailVC: BaseVC {
    
    var isDraging = false
    @IBOutlet weak var scrollView: TodayDetailScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerImageTop: NSLayoutConstraint!
    @IBOutlet weak var contentLabelTop: NSLayoutConstraint!
    
    var swipeInteractionController: SwipeInteractionController?
    var dismissToRect: CGRect?
    var lastVC: TodayVC?
    
    var title1: UILabel!
    var title2: UILabel!
    var closeBtn: UIButton!
    //流畅退场动画（点击关闭按钮时使用）
    var fluentAnimaition = false
    
    deinit {
        print("DetailVC Released!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置手势转场控制器
        swipeInteractionController = SwipeInteractionController(viewController: self)
        
        //创建标题
        title1 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            $0.text = "出游专题"
            $0.sizeToFit()
            headerView.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.top.equalTo(15)
                make.left.equalTo(15)
                make.right.lessThanOrEqualTo(-15)
            }
        }
        
        
        title2 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
            $0.textColor = .white
            $0.text = "与家人一起旅行"
            $0.sizeToFit()
            headerView.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.top.equalTo(39)
                make.left.equalTo(12)
                make.right.lessThanOrEqualTo(-12)
            }
        }
        
        
        //创建关闭按钮
        closeBtn = UIButton.init(type: .custom).then({ (closeBtn) in
            closeBtn.setImage(UIImage.init(named: "close"), for: .normal)
            closeBtn.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
            closeBtn.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
            closeBtn.layer.cornerRadius = 12.5
            closeBtn.layer.masksToBounds = true
            //此处设置bounds并不是多此一举，不设置在转场动画中取不到按钮的snapshot
            closeBtn.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
            self.view.addSubview(closeBtn)
            closeBtn.snp.makeConstraints { (make) in
                make.top.equalTo(15)
                make.right.equalTo(-15)
                make.width.height.equalTo(25)
            }
        })
        

        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: ScreenWidth*1.2, left: 0, bottom: 0, right: 0)
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.setStatusBar(forHidden: true, forStyle: .default, forAnimation: .slide)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transitioningDelegate = self
    }
    
    
//    点击关闭按钮
    @objc func clickClose() {
        fluentAnimaition = true
        self.dismiss(animated: true, completion: nil)
    }

}

extension TodayCardDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY <= 0 {
            headerImageTop.constant = offsetY
            title1.snp.updateConstraints { (make) in
                make.top.equalTo(15+offsetY)
            }
            title2.snp.updateConstraints { (make) in
                make.top.equalTo(39+offsetY)
            }
            
            if isDraging {
                contentLabelTop.constant = 27 + offsetY
                scrollView.showsVerticalScrollIndicator = false
            }
        } else {
            headerImageTop.constant = 0
            title1.snp.updateConstraints { (make) in
                make.top.equalTo(15)
            }
            title2.snp.updateConstraints { (make) in
                make.top.equalTo(39)
            }
            contentLabelTop.constant = 27
            scrollView.showsVerticalScrollIndicator = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
        
//        let offsetY = scrollView.contentOffset.y
//
//        if offsetY < 0 {
//            scrollView.isScrollEnabled = false
//        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDraging = false
//        scrollView.isScrollEnabled = true
    }
}

extension TodayCardDetailVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let finalFrame = self.dismissToRect {
            return ShrinkDismissAnimationController(finalFrame: finalFrame, interactionController: swipeInteractionController, fluentAnimation: self.fluentAnimaition)
        } else {
            return nil
        }
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? ShrinkDismissAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress
            else {
                return nil
        }
        interactionController.delegate = self
        return interactionController
    }
}

extension TodayCardDetailVC: SwipeInteractionDelegate {
    func SwipeInteractionAskToShowTabBar() {
        guard let vc = lastVC else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            vc.setStatusBar(forHidden: false, forStyle: .default, forAnimation: .slide)
        })
    }
}

