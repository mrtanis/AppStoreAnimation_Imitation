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
}
