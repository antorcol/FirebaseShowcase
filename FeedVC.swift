//
//  FeedVCViewController.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/24/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import Firebase
//import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPost: MaterialTextField!
    @IBOutlet weak var btnGetImage: MaterialButton!
    
    //MARK: Variables
    
    var cameraWithFlash:String = "📸"
    var posts = [Post]()
    static var imageCache = NSCache()
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImageView = UIImageView()
    var selectedImageTempLocation: String!
    var imageIsSelected: Bool = false
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
    
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary //for this app
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: {snapshot in
            
            self.posts = [] //should this be inside the if block?
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        
        
    }

    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            //if the user has clicked already, cancel that request
            cell.request?.cancel()
            
            var img: UIImage?
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            cell.configureCell(post, image: img)
            return cell
        }
        return PostCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageUrl == nil || post.imageUrl?.characters.count <= 0 {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    
    //MARK: Utility
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageIsSelected = true
        //TODO: remove image and return to icon?
        
        //save to temp location
        selectedImageTempLocation = NSTemporaryDirectory()
        selectedImageTempLocation.appendContentsOf("/tempImage.jpg")
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.2)!
        let fileURL = NSURL(fileURLWithPath: selectedImageTempLocation)
        imageData.writeToURL(fileURL, atomically: true)
        
        //dismiss
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        //set button
        btnGetImage.setBackgroundImage(image, forState: .Normal)
        btnGetImage.setTitle("", forState: .Normal)
        selectedImage.image = image
    }
    
//    func getClientId() {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
//        let documentsDirectory = paths[0] as! String
//        let path = documentsDirectory.stringByAppendingPathComponent("GoogleService-Info.plist")
//        let fileManager = NSFileManager.defaultManager()
//        //check if file exists
//        if(!fileManager.fileExistsAtPath(path)) {
//            
//
//
//            
//        }
//        
//        
//    }
    
    
    func postToFirebase(imgUrl: String?) {

        var post: Dictionary<String, AnyObject> =  [
        
            "description": self.txtPost.text!,
            "totalLikes": 0
        ]
        
        if(imgUrl != nil) {
            post["imageUrl"] = imgUrl
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        txtPost.text = ""
        
        btnGetImage.setBackgroundImage(nil, forState: .Normal)
        btnGetImage.setTitle(cameraWithFlash, forState: .Normal)
        
        tableView.reloadData()
    }
    
    
    //TODO - shorter name
    func makeImageName() -> String {
        let uuid = NSUUID().UUIDString
        print(uuid)
        return "\(uuid).jpg"
    }
    
    //MARK: Actions
    @IBAction func btnGetImage_Pressed(sender: UIButton) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func btnPost_Pressed(sender: MaterialButton) {
        
        if let postedTxt = self.txtPost?.text where postedTxt != "" {
            
            if let _ = self.selectedImage.image where imageIsSelected == true {

                if selectedImageTempLocation != "" {
                    //the image exists where we expect, and is already jpeg
                    let fileURL = NSURL(fileURLWithPath: selectedImageTempLocation)
                    let fullImageLink = "\(myAmazonS3SavingFolder)/" + makeImageName()
                    print(fullImageLink)
                    amazonS3Manager.putObject(fileURL, destinationPath: fullImageLink)
                    
                    //TODO delete the temp file
                    
                    //post to Firebase
                    postToFirebase(fullImageLink)
                    
                } else {
                    print("some big error saving to S3")
                    
                }
                
                
                //upload text content
                
            } else {
                postToFirebase(nil)

            }
            
            //reset
            imageIsSelected = false
            
        }
    }
    
    
    
    @IBAction func btnSignOut_Pressed(sender: UIBarButtonItem) {
        
        
        //TODO: If google, etc
        GIDSignIn.sharedInstance().signOut()
        
        //TODO: Else
        let myRootRef = DataService.ds.REF_BASE
        myRootRef.unauth()
        
        //Either
        NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    

}
