//
//  ViewController.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/19/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, GIDSignInUIDelegate {

    //MARK:Firebase data service
    let myRootRef = DataService.ds.REF_BASE
    
    //MARK:Google automatic sign in
    @IBOutlet weak var GoogleSignInButton: MaterialButton!
    @IBOutlet weak var lblGoogleSignInLabel: UILabel!
    
    //MARK:Using Firebase email login
    @IBOutlet weak var standardSignInButton: MaterialButton!
    @IBOutlet weak var txtStdEmailAddress: MaterialTextField!
    @IBOutlet weak var txtStdSignInPassword: MaterialTextField!
    
    //MARK:Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for testing google
        GIDSignIn.sharedInstance().signOut()
        
        //for testing firebase
        //myRootRef.unauth()
        //NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            let appD = UIApplication.sharedApplication().delegate as! AppDelegate
            let tkn = appD.googleAuthToken
            
            myRootRef.authWithOAuthProvider("google", token: tkn, withCompletionBlock: { (error: NSError!, authData: FAuthData!) in
                if authData != nil {
                    // Firebase user authenticated with Google creds
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    
                    let user = ["provider": authData.provider!]
                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                    
                    self.performSegueWithIdentifier(LOGGED_IN_SEGUE_NAME, sender: nil)
                    
                } else {
                    print("Problem signing in with Google credentials: \(error.description)!!")
                    // No user is signed in
                }
                
            })
            
            print("ViewDidLoad: Signed in with Google!")
        } else {
            print("ViewDidLoad: Not signed in with Google")
        }
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(LOGGED_IN_SEGUE_NAME, sender: nil)
            print("I'm gone!")
        }
    }

    //MARK:Actions
    @IBAction func standardSignInButton_Pressed(sender: MaterialButton) {
        
        //could have used let with (let email, let pw...)
        if txtStdEmailAddress.text?.characters.count > 0 &&  txtStdSignInPassword.text?.characters.count > 0
        {
            myRootRef.authUser(txtStdEmailAddress.text!, password: txtStdSignInPassword.text) {
                error, authData in
                if error != nil {
                    self.handleSignInError(error.code)
                } else {
                    print("Signed in using email / pw user credentials!")
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    
                    let user = ["provider": "app.credentials"]
                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                    
                    self.performSegueWithIdentifier(LOGGED_IN_SEGUE_NAME, sender: nil)
                }
            }
        } else {
            showErrorAlert("Need Credentials", msg: "Please provide a valid email address and password.")
        }
        
    }
    
    
    //MARK:Utility
    func handleSignInError(erCode:Int) {
        if erCode == NO_SUCH_FIREBASE_USER {
            addNewUser(self.txtStdEmailAddress.text!, pw: self.txtStdSignInPassword.text!)
        } else if erCode == BAD_FIREBASE_PASSWORD || erCode == INVALID_FIREBASE_EMAIL || erCode == FIREBASE_EMAIL_TAKEN || erCode == AUTH_PROVIDER_INVALID_CREDS {
            self.showErrorAlert("Bad Credentials", msg: "Username or password is unknown. Please provide a valid email address and password.")
        } else if erCode == AUTH_PROVIDER_INTERNAL_ERROR || erCode == AUTH_PROVIDER_LIMITS_EXCEEDED {
            showErrorAlert("Authentication Issue", msg: "Your signin provider (Google, Facebook, etc) returned an error.")
        } else {
            self.showErrorAlert("Unknown Error", msg: "Unexpected error returned: Code: \(erCode).")
        }
        
    }

    
    func addNewUser(email:String, pw:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Unknown Email", message: "\"\(email)\" is not found in the system. Would you like to create a new account using the email address and password you provided?", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let addAccountAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            DataService.ds.REF_BASE.createUser(email, password: pw, withValueCompletionBlock: { (
                error, result) in
                if error != nil {
                    self.showErrorAlert("Can't create account", msg: "There was an unexpected error in trying to create your account: \(error.description).")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        actionSheetController.addAction(addAccountAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    

//Save for logout menu
//    @IBAction func GoogleSignOutButton_Pressed(sender: MaterialButton) {
//        
//        GIDSignIn.sharedInstance().signOut()
    //myRootRef.unauth()
    //NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
//
//    }

    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

