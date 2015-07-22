//
//  ViewController.swift
//  SWMeetups
//
//  Created by Steve Walsh on 07/07/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

import UIKit

class MeetupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet var tableView: UITableView!
  
  var items = NSMutableArray()
  
  let imageCellIdentifier = "ImageCell"
  
  func addDummyData() {

  }
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    refreshData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    deselectAllRows()
  }
  
  func deselectAllRows() {
    if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
      for indexPath in selectedRows {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
      }
    }
  }
  
  // MARK: Refresh Content
  
  func refreshData() {

    self.showProgressHUD()
    
    SWNetworkManager.sharedInstance.getMeetups { json in
      let results = json
      for (index: String, subJson: JSON) in results {
        let user: AnyObject = subJson.object
        self.items.addObject(user)
      }
      self.hideProgressHUD()
      self.reloadTableViewContent()
    }
  }
  
  func showProgressHUD() {
    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
      var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud.labelText = "Loading"
    //})
  }
  
  func hideProgressHUD() {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
      println("Finished")
    })
  }
  
  func reloadTableViewContent() {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      self.tableView.reloadData()
      self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
    })
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count;
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = self.tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier) as! ImageCell
  
    let meetup:JSON =  JSON(self.items[indexPath.row])
    
    let picURL = meetup["image_url"].string
    let url = NSURL(string: picURL!)
    let data = NSData(contentsOfURL: url!)
    cell.customImageView.image = UIImage(data: data!)
    cell.titleLabel.text = meetup["name"].string
    
    if let subtitle = meetup["description"].string {
      
      let desc = subtitle as NSString
      
      // Some subtitles are really long, so only display the first 200 characters
      if desc.length > 200 {
        cell.subtitleLabel.text = "\(desc.substringToIndex(200))..."
        
      } else {
        cell.subtitleLabel.text = desc as String
      }
      
    } else {
      cell.subtitleLabel.text = ""
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if isLandscapeOrientation() {
      return 140.0
    } else {
      return 235.0
    }
  }
  
  func isLandscapeOrientation() -> Bool {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let indexPath = tableView.indexPathForSelectedRow()
    let item: AnyObject = items[indexPath!.row]
    
    let detailViewController = segue.destinationViewController as! MeetupDetailViewController
    detailViewController.meetup = JSON(item)
  }
}

