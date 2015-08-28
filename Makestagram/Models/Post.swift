//
//  Post.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class Post : PFObject, PFSubclassing {
  
  @NSManaged var imageFile: PFFile?
  @NSManaged var user: PFUser?
  
  var image: UIImage?
  var photoUploadTask: UIBackgroundTaskIdentifier?
  
  
  //MARK: PFSubclassing Protocol
  static func parseClassName() -> String {
    return "Post"
  }
  
  override init() {
    super.init()
  }
  
  override class func initialize() {
    var onceToken: dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      // inform Parse about this subclass
      self.registerSubclass()
    }
  }
  
  func uploadPost() {
    if let image = image {
      
      photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
        () -> Void in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
      
      let imageData = UIImageJPEGRepresentation(image, 1.0)!
      let imageFile = PFFile(data: imageData)
      imageFile.saveInBackgroundWithBlock(nil)
      
      user = PFUser.currentUser()
      self.imageFile = imageFile
      saveInBackgroundWithBlock {
        (success: ObjCBool, error: NSError?) -> Void in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
    }
  }
}