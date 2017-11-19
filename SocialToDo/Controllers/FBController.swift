//
//  FBController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FacebookLogin

protocol FBControllerDelegate {
    func promptFacebookLogin()
}

class FBController{
    var delegate:FBControllerDelegate?
    
    init(){
        
    }
    
    func checkLogin(){
        if (AccessToken.current == null){
            delegate.promptFacebookLogin()
        }
    }
}
