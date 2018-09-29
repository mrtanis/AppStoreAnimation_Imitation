//
//  TodayCardDetailVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/29.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayCardDetailVC: UIViewController {

    var statusBarHidden = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerImageTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
//        scrollView.contentOffset = CGPoint(x: 0, y: 300)
//        scrollView.contentInset = UIEdgeInsets(top: 439, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
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
