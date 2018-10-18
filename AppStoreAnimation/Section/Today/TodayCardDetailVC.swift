//
//  TodayCardDetailVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/29.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayCardDetailVC: BaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerImageTop: NSLayoutConstraint!
    
    var dismissToRect: CGRect?
    
    var title1: UILabel!
    var title2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建标题
        title1 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            $0.text = "生活解决方案"
        }
        title1.sizeToFit()
        headerImage.addSubview(title1)
        title1.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
//            make.height.equalTo(title1.bounds.height)
        }
        
        title2 = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
            $0.textColor = .white
            $0.text = "帮你找份理想工作"
        }
        title2.sizeToFit()
        headerImage.addSubview(title2)
        title2.snp.makeConstraints { (make) in
            make.top.equalTo(39)
            make.left.equalTo(12)
            make.right.equalTo(-12)
//            make.height.equalTo(title2.bounds.height)
        }
        
        //隐藏标题
        title1.isHidden = true
        title2.isHidden = true
        
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: ScreenWidth*1.2, left: 0, bottom: 0, right: 0)
        scrollView.delegate = self
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImage))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        headerImage.addGestureRecognizer(tap)
        headerImage.isUserInteractionEnabled = true

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIView.animate(withDuration: 0.5) {
//            self.setStatusBar(forHidden: false, forStyle: .default, forAnimation: .slide)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func tapImage() {
        self.dismiss(animated: true) {
            UIView.animate(withDuration: 0.5) {
                self.setStatusBar(forHidden: false, forStyle: .default, forAnimation: .slide)
            }
        }
    }

}

extension TodayCardDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headerImageTop.constant = offsetY
        } else {
            headerImageTop.constant = 0
        }
    }
}

extension TodayCardDetailVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let finalFrame = self.dismissToRect {
            return ShrinkDismissAnimationController(finalFrame: finalFrame)
        } else {
            return nil
        }
        
    }
}
