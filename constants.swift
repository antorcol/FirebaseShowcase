//
//  constants.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/19/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit
import AmazonS3RequestManager

let SHADOW_COLOR:CGFloat = 157.0 / 255.0
let KEY_UID:String = "uid"

let LOGGED_IN_SEGUE_NAME:String = "LoggedInSegue"

let myAmazonS3Bucket:String = "somebucket66"
let myAmazonS3SavingFolder:String = "test-images"
let myAmazonS3AccessKey: String = "AKIAJEE3QL67HLZVUS6A"
let myAmazonS3Secret: String = "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"


/*
 FAuthenticationErrorInvalidEmail = -5
 FAuthenticationErrorInvalidPassword = -6
 FAuthenticationErrorInvalidToken = -7
 FAuthenticationErrorUserDoesNotExist = -8
 FAuthenticationErrorEmailTaken = -9
 
 //PROVIDERS
 FAuthenticationErrorInvalidCredentials = -11,
 --FAuthenticationErrorInvalidArguments = -12,
 FAuthenticationErrorProviderError = -13,
 FAuthenticationErrorLimitsExceeded = -14,
*/

let INVALID_FIREBASE_EMAIL:Int = -5
let BAD_FIREBASE_PASSWORD:Int = -6
let INVALID_FIREBASE_TOKEN:Int = -7
let NO_SUCH_FIREBASE_USER: Int = -8
let FIREBASE_EMAIL_TAKEN: Int = -9
let AUTH_PROVIDER_INVALID_CREDS:Int = -11
let AUTH_PROVIDER_INTERNAL_ERROR:Int = -13
let AUTH_PROVIDER_LIMITS_EXCEEDED:Int = -14

//AWS
let amazonS3Manager = AmazonS3RequestManager(bucket: myAmazonS3Bucket,
                                             region: .USStandard,
                                             accessKey: myAmazonS3AccessKey,
                                             secret: myAmazonS3Secret)