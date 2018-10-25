//
//  TodayVC.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/26.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

//手指最大移动距离
private let maxMoveDistance:CGFloat = 20.0
class TodayVC: BaseVC {

    var beginOffsetY: CGFloat?
    var currentTouchCell: TodayCardCell?
    
    var currentTouchCellOriginFrame: CGRect?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        title = "Today"
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.registerReusableSupplementaryView(elementKind: UICollectionView.elementKindSectionHeader, TodayCardHeaderView.self)
        layout.itemSize = CGSize(width: ScreenWidth-40, height: (ScreenWidth-40)*1.2)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.setTabBarVisible(visible: true, animated: true, timeInterval: 0.5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentTouchCell?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        

        UIView.animate(withDuration: 0, animations: {
            self.setStatusBar(forHidden: true, forStyle: .default, forAnimation: .slide)
        }) { (finished) in
            self.setTabBarVisible(visible: false, animated: true, timeInterval: 0.5)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentTouchCell?.isHidden = true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodayCardDetailSegue" {
            let toVC = segue.destination as! TodayCardDetailVC
            toVC.transitioningDelegate = self
            toVC.dismissToRect = self.currentTouchCellOriginFrame
            toVC.lastVC = self
        }
    }

    func delayShowTabBar() {
        perform(#selector(showTabBar), with: nil, afterDelay: 0.5)
    }
    
    
    @objc func showTabBar() {
        UIView.animate(withDuration: 0.5) {
            self.setStatusBar(forHidden: false, forStyle: .default, forAnimation: .slide)
        }
        self.setTabBarVisible(visible: true, animated: true, timeInterval: 0.5)
    }
    

}

extension TodayVC: TodayCardCellDelegate {
    //跳转详情代理
    func jumpToCardDetail(fromCell cell: TodayCardCell) {
        self.performSegue(withIdentifier: "TodayCardDetailSegue", sender: nil)
    }
    //更新点击cell初始frame
    func updateBeginTouchFrame(cellFrame rect: CGRect, ofCell cell: TodayCardCell) {
        if self.currentTouchCellOriginFrame == nil {
            self.currentTouchCellOriginFrame = collectionView.convert(rect, to: self.view)
        }
        
    }
}

extension TodayVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as TodayCardCell
        cell.delegate = self
        cell.touchClosure = {
            (cell) in
            self.currentTouchCell = cell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0{
            headerView = collectionView.dequeueReusableSupplementaryView(elementKind: kind, indexPath: indexPath) as TodayCardHeaderView
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: ScreenWidth, height: 108)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }
}

extension TodayVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension TodayVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginOffsetY = scrollView.contentOffset.y
        if let cell = currentTouchCell {
            cell.isFingerOn = true
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
        guard let beginOffsetY = self.beginOffsetY else {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let offsetYDiff = abs(offsetY - beginOffsetY)
        if offsetYDiff > maxMoveDistance {
            if let cell = currentTouchCell, cell.restoreExcuted == false, cell.isFingerOn {
                cell.restoreExcuted = true
                cell.calculateTimeInterval()
                cell.restore()
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging")
        guard let cell = currentTouchCell else {
            return
        }
        cell.isFingerOn = false
        cell.calculateTimeInterval()
        cell.restore()
        cell.restoreExcuted = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TodayVC-touchesBegan")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TodayVC-touchesMoved")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TodayVC-touchesEnded")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TodayVC-touchesCancelled")
    }
}

extension TodayVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ExtendPresentAnimationController(originFrame: (currentTouchCell!.convert(currentTouchCell!.bounds, to: self.view)))
    }
}
