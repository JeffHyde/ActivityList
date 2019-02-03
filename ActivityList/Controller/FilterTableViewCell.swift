//
//  FilterTableViewCell.swift
//  ActivityList
//
//  Created by Jeff  Hyde on 6/13/18.
//  Copyright © 2018 Jeff  Hyde. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var activityTitleLabel: UILabel!
    
    func configure(data: String,
                   index: Int) {
        activityTitleLabel.text = data
        if index == 0  {
            starButton.isHidden = true
        }
        starButton.tag = index
        if let text = activityTitleLabel.text {
            if DataHelper.shared.favoriteActivities.contains(text) {
                starButton.isSelected = true
                starButton.setImage(#imageLiteral(resourceName: "StarOn"),
                                    for: .selected)
            }
        }
    }
    
}
