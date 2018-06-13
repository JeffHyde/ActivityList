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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
