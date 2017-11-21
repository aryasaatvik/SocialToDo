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

class FBController{
    var loggedIn = false
    var delegate:FBControllerDelegate?
    var accessToken:AccessToken?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var todoControl:TodoController?
    
    init(){
        todoControl = appDelegate.todoControl
    }
    
    func checkLogin(){
        if (!loggedIn){
            delegate!.promptFacebookLogin()
        }
    }
	
	func login(vc: UIViewController) {
		let loginManager = LoginManager()
		loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: vc) { (loginResult) in
			switch loginResult {
			case .failed(let error):
				print(error)
			case .cancelled:
				print("User cancelled login.")
			case .success(let grantedPermissions, let declinedPermissions, let accessToken):
				self.accessToken = accessToken
				self.loggedIn = true
				print("Logged in!")
			}
		}
	}
    
    func logout() {
        accessToken = nil
        loggedIn = false
    }
    
    func getUID() -> String{
        //TODO: Figure out why userId could possibly be nil and handle that
        //Also handle the not logged-in case
        return (accessToken?.userId)!
    }
}
