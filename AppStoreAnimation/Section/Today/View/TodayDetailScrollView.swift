//
//  TodayDetailScrollView.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2019/3/14.
//  Copyright © 2019 mrtanis. All rights reserved.
//

import UIKit

class TodayDetailScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    //允许同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
