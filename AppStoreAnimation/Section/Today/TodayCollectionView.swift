//
//  TodayCollectionView.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/27.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayCollectionView: UICollectionView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view
    }

    
}

