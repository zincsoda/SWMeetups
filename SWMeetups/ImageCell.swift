//
//  ImageCell.swift
//  SWMeetups
//
//  Created by Steve Walsh on 19/07/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subtitleLabel: UILabel!
  @IBOutlet var customImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
