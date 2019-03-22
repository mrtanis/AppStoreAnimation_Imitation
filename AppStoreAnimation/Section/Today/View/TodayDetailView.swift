//
//  TodayDetailView.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2019/3/15.
//  Copyright © 2019 mrtanis. All rights reserved.
//

import UIKit

class TodayDetailView: UIView, UIGestureRecognizerDelegate {

    //允许同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
