//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var likesIconImageView: UIImageView!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  
  @IBAction func tappedLikeButton(sender: AnyObject) {
    post?.toggleLikePost(PFUser.currentUser()!)
  }
    
  var post: Post? {
    didSet {
      
      if let oldValue = oldValue where oldValue != post {
          oldValue.image.value = nil
      }
      
      if let post = post {
        post.image
          .bindTo(postImageView.bnd_image)
        
        post.likes
          .observe { (value: [PFUser]?) -> () in

          if let value = value {
            self.likesLabel.text = self.stringFromUserList(value)
            self.likeButton.selected = value.contains(PFUser.currentUser()!)
            self.likesIconImageView.hidden = (value.count == 0)
          } else {
            self.likesLabel.text = ""
            self.likeButton.selected = false
            self.likesIconImageView.hidden = true
          }
        }
      }
    }
  }
  
  func stringFromUserList(userList: [PFUser]) -> String {
    // 1
    let usernameList = userList.map { user in user.username! }
    // 2
    let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
    
    return commaSeparatedUserList
  }
}
