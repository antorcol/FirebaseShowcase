//
//  Post.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/27/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    //MARK: vars
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _userName: String!
    private var _postKey: String!
    private var _postRef: Firebase!
    
    //MARK: inits
    init(postDescription:String, imageUrl: String?, userName: String){
        _postDescription = postDescription
        _imageUrl = imageUrl
        _userName = userName
        _likes = 0
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let likes = dictionary["totalLikes"] as? Int {
            self._likes = likes
        } else {
            self._likes = 0
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let postDescription = dictionary["description"] as? String {
            self._postDescription = postDescription
        }
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
        
    }
    
    //MARK: Functions
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            if _likes > 0  {
                _likes = _likes - 1
            }
        }
        
        self._postRef.childByAppendingPath("totalLikes").setValue(self._likes)
    }
    
    //MARK: Public Vars
    var postDescription: String {
        get {
            return self._postDescription
        }
    }
    
    var imageUrl: String? {
        get {
            
            return self._imageUrl
        }
    }
    
    var likes: Int {
        get {
            return self._likes
        }
    }
    
    var userName: String {
        get {
            return self._userName
        }
    }
    
    var postKey: String {
        get {
            return self._postKey
        }
    }
}