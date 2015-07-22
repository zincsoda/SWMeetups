//
//  MeetupDetailViewController.swift
//  SWMeetups
//
//  Created by Steve Walsh on 20/07/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

import UIKit

class MeetupDetailViewController: UIViewController {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var imageView: UIImageView?
  @IBOutlet var subtitleLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  
  var meetup:JSON = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setImageViewImage()
    titleLabel.text = meetup["name"].string
    subtitleLabel.text = meetup["description"].string
  }

  func setImageViewImage() {
    
    let picURL = meetup["image_url"].string
    let url = NSURL(string: picURL!)
    let data = NSData(contentsOfURL: url!)
    imageView?.image = UIImage(data: data!)
  }

    


}
