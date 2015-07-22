//
//  SWNetworkManager.swift
//  SWMeetups
//
//  Created by Steve Walsh on 19/07/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

import UIKit


typealias ServiceResponse = (JSON, NSError?) -> Void

class SWNetworkManager: NSObject {
  
  static let sharedInstance = SWNetworkManager()
  
  let baseURL = "http://localhost:5005/meetups.json"
//  let baseURL = "http://hidden-retreat-2574.herokuapp.com/meetups.json"
  
  func getMeetups(onCompletion: (JSON) -> Void) {
    let route = baseURL
    makeHTTPGetRequest(route, onCompletion: { json, err in
      onCompletion(json as JSON)
    })
  }
  
  func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
    let request = NSMutableURLRequest(URL: NSURL(string: path)!)
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      let json:JSON = JSON(data: data)
      onCompletion(json, error)
    })
    task.resume()
  }
  
  func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
    var err: NSError?
    let request = NSMutableURLRequest(URL: NSURL(string: path)!)
    
    // Set the method to POST
    request.HTTPMethod = "POST"
    
    // Set the POST body for the request
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      let json:JSON = JSON(data: data)
      onCompletion(json, err)
    })
    task.resume()
  }
}