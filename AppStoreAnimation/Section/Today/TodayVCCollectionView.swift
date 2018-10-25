//
//  TodayVCCollectionView.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/10/25.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayVCCollectionView: UICollectionView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("CollectionView-touchesBegan")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("CollectionView-touchesMoved")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("CollectionView-touchesEnded")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("CollectionView-touchesCancelled")
    }

    
}
