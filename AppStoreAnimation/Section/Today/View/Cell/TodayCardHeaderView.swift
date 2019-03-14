//
//  TodayCardHeaderView.swift
//  AppStoreAnimation
//
//  Created by mrtanis on 2018/9/28.
//  Copyright © 2018 mrtanis. All rights reserved.
//

import UIKit

class TodayCardHeaderView: UICollectionReusableView, Reusable {
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        let date = Date()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "M月d日 星期五"
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
    }
    
}
