//
//  FBController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

protocol FBControllerDelegate {
    func promptFacebookLogin()
}

class FBController{
    var loggedIn = false
    var delegate:FBControllerDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
	

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
			case .success(let grantedPermissions, let declinedPermissions, let fbAccessToken):
				let credential = FacebookAuthProvider.credential(withAccessToken: fbAccessToken.authenticationToken)
				// login to firebase
				Auth.auth().signIn(with: credential, completion: { (user, error) in
					if let error = error {
						print("Firebase Auth Error \(error)")
					}
					self.loggedIn = true
					print("Logged in!")
					
					// get user info and upload to Firebase
					// create facebook graph request
					struct UserInfoRequest: GraphRequestProtocol {
						struct Response: GraphResponseProtocol {
							var name: String?
							var email: String?
							init(rawResponse: Any?) {
								// Decode JSON from rawResponse into other properties here.
								guard let response = rawResponse as? Dictionary<String, Any> else {
									return
								}
								if let name = response["name"] as? String {
									self.name = name
								}
	
								if let email = response["email"] as? String {
									self.email = email
								}
							}
						}
						
						var graphPath = "/me"
						var parameters: [String : Any]? = ["fields": "name, email"]
						var accessToken = AccessToken.current
						var httpMethod: GraphRequestHTTPMethod = .GET
						var apiVersion: GraphAPIVersion = .defaultVersion
					}
					
					// initiate facebook graph request
					let connection = GraphRequestConnection()
					connection.add(UserInfoRequest()) { response, result in
						switch result {
						case .success(let response):
							// add user info to firebase database
							var ref: DatabaseReference!
							ref = Database.database().reference()
							let userRef = ref.child("users/\((user?.uid)!)/")
							let userInfo = ["name": response.name!,
											"email": response.email!]
							userRef.updateChildValues(userInfo)
						case .failed(let error):
							print("User Info Graph Request Failed: \(error)")
						}
					}
					connection.start()
					
					// initialize MyLists TodoController
					self.appDelegate.listControl = TLListController()
					self.appDelegate.friendsControl = FriendsController()
					
					// segue to tabbarcontroller
					let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
					if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController {
						vc.present(tabBarVC, animated: true, completion: nil)
					}
				})
			}
		}
	}
    
	func logout(vc: UIViewController) {
		let loginManager = LoginManager()
		loginManager.logOut()
		
		// TODO:// firebase logout
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print("Error signing out: \(signOutError)")
		}
		
		loggedIn = false
		
		// TODO:// present loginvc
		
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let loginVC = storyboard.instantiateViewController(withIdentifier: "FacebookLogin")
		vc.present(loginVC, animated: true, completion: nil)
		

    }
}
