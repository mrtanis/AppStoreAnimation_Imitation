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
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏标题
        title1.isHidden = true
        title2.isHidden = true
        
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
