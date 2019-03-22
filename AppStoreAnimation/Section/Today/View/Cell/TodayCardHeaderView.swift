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
        let dateStr = date.dateString(.md(.half(.zh)))
        let weekdayStr = date.weekdayString(.full(.zh))
        dateLabel.text = dateStr + " " + weekdayStr
    }
    
}
