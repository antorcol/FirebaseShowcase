//
//  MaterialButton-GoogleSignin.swift
//  ATC-Firebase-Showcase
//
//  Created by Anthony Torrero Collins on 4/21/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class MaterialButton_GoogleSignin: GIDSignInButton {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red:SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }

}
