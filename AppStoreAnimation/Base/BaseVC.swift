//
//  BaseVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/30.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    //状态栏显示状态
    var _statusBarHidden = false
    //状态栏显示风格
    var _statusBarStyle = UIStatusBarStyle.default
    //状态栏动画类型
    var _statusBarAnimation = UIStatusBarAnimation.none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
// MARK: - 设置状态栏
    func setStatusBar(forHidden state: Bool) {
        _statusBarHidden = state
        _statusBarStyle = UIStatusBarStyle.default
        setStatusBar(forHidden: _statusBarHidden, forStyle: _statusBarStyle)
    }

    func setStatusBar(forHidden state: Bool, forStyle style: UIStatusBarStyle) {
        _statusBarHidden = state
        _statusBarStyle = style
        _statusBarAnimation = UIStatusBarAnimation.none
        setStatusBar(forHidden: _statusBarHidden, forStyle: _statusBarStyle, forAnimation: _statusBarAnimation)
    }
    
    func setStatusBar(forHidden state: Bool, forStyle style: UIStatusBarStyle, forAnimation animation:UIStatusBarAnimation) {
        _statusBarHidden = state
        _statusBarStyle = style
        _statusBarAnimation = animation
        
        if self.responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return _statusBarHidden
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return _statusBarStyle
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return _statusBarAnimation
    }
    
    
    
    // MARK: - 设置tabbar
    func setTabBarVisible(visible:Bool, animated:Bool, timeInterval:TimeInterval) {
        
        guard let _ = self.tabBarController else {
            return
        }
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
//        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? timeInterval : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            if visible {
                self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: (frame?.width)!, height: height!)
                self.tabBarController?.tabBar.isHidden = false
            } else {
                self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.maxY - height!, width: (frame?.width)!, height: height!)
            }
//            UIView.animate(withDuration: duration) {
//                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
//                return
//            }
            UIView.animate(withDuration: duration, animations: {
                if visible {
                    self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.maxY - height!, width: (frame?.width)!, height: height!)
                } else {
                    self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.maxY, width: (frame?.width)!, height: height!)
                }
            }) { (finished) in
                if !visible {
                    self.tabBarController?.tabBar.isHidden = true
                }
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
//    @IBAction func tapped(sender: AnyObject) {
//        setTabBarVisible(visible: !tabBarIsVisible(), animated: true)
//    }
}
