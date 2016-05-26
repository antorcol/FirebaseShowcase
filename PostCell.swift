//
//  PostCellTableViewCell.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/24/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnFavs: UIButton!
    
    //MARK: Variables
    var post:Post!
    var request: Request?
    var localNameForImage: String?
    var likeRef: Firebase!
    
    //MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(post: Post, image: UIImage?) {
        
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("totalLikes").childByAppendingPath(post.postKey)
        
        self.postDescription.text = post.postDescription
        self.lblLikes.text = "\(post.likes)"
        
        //image is already present, perhaps it is in the table view, having
        //   been scrolled past already
        if image != nil {
            self.showcaseImg.image = image
            self.showcaseImg.hidden = false
        } else {
            //is there a url at all?
            if self.post.imageUrl != nil {
                //hide while loading
                self.showcaseImg.hidden = true
                
                //make the local name
                let urlComponents = self.post.imageUrl?.componentsSeparatedByString("/")
                let nameComponent = urlComponents?.last
                
                
                //can we save directly to the cache
                let destination: NSURL = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)[0]
                
                //TODO: all this
                //amazonS3Manager.downloadObject(self.post.imageUrl!, saveToURL: destination)
                
//                do  {
//                    //first just try to get the file to see the error object in place
//                    amazonS3Manager.downloadObject(self.post.imageUrl!, saveToURL: destination)
//                    
//                } catch  {
//                    print("no image in PostCell.configureCell!")
//                }
                
            } else {
                self.showcaseImg.hidden = true
            }
            
            //check for this user having previously liked this postpendingPath("totalLikes").childByAppendingPath(post.postKey)
            likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.btnFavs.highlighted = false
                } else {
                    self.btnFavs.highlighted = true
                }
            })
        }
        
        
    }
    
    @IBAction func btnFavs_Pressed(sender: UIButton) {
        
        sender.selected = !sender.selected
        if sender.selected {
            sender.highlighted = true
            self.likeRef.setValue(true)
            self.post.adjustLikes(true)
        } else {
            sender.highlighted = false
            self.likeRef.removeValue()
            self.post.adjustLikes(false)
        }
        
    }

}


/* putting here for short-term ref
 
 //this is for non-S3
 
 //                let destination: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
 
 //                request = Alamofire.request(.GET, self.post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
 //                    if error == nil && data != nil {
 //
 //                        let img = UIImage(data: data!)!
 //                        self.showcaseImg.image = img
 //                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
 //                        self.showcaseImg.hidden = false
 //                    }
 //                })
 
 
 
 */*/
 
