//
//  NavVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/26.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    var popDelegate: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popDelegate = self.interactivePopGestureRecognizer?.delegate;
        self.delegate = self;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 处理滑动返回手势
extension NavVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            self.interactivePopGestureRecognizer?.delegate = popDelegate as? UIGestureRecognizerDelegate
        } else {
            self.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
