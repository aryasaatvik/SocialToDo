//
//  FBController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FacebookCore
import FacebookLogin

protocol FBControllerDelegate {
    func promptFacebookLogin()
}

class FBController:LoginButtonDelegate{
    var loggedIn = false
    var delegate:FBControllerDelegate?
    var accessToken:AccessToken?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var todoControl:TodoController?
    
    init(){
        todoControl = appDelegate.todoControl
    }
    
    func checkLogin(){
        if (loggedIn == false){
            delegate!.promptFacebookLogin()
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success(grantedPermissions: _, declinedPermissions: _, token: let fbAccessToken):
            self.accessToken = fbAccessToken
            loggedIn = true
        case .cancelled:
            //TODO: Handle a cancelation.
            break
        case .failed(let err):
            //TODO: Handle this better
            print(err)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        accessToken = nil
        loggedIn = false
    }
    
    func getUID() -> String{
        //TODO: Figure out why userId could possibly be nil and handle that
        //Also handle the not logged-in case
        return (accessToken?.userId)!
    }
}
