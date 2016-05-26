//
//  DataService.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/23/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE: String = "https://glaring-inferno-3220.firebaseio.com"

//create a singleton
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: URL_BASE)
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        get {
            return _REF_BASE
        }
    }
    
    var REF_POSTS: Firebase {
        get {
            return self._REF_POSTS
        }
    }
    
    var REF_USERS: Firebase {
        get {
            return self._REF_USERS
        }
    }
    
    var REF_USER_CURRENT: Firebase {
        
        
        get {
            let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
            let user = REF_USERS.childByAppendingPath(uid)
            
            //Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
            return user!
        }
    }
    
    func createFirebaseUser(uid:String, user:Dictionary<String,String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}