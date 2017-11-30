//
//  FacebookIntegration.swift
//  SocialToDo
//
//  Created by Brannen Hall on 11/28/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import FacebookCore
import FacebookAuth

protocol  FacebookIntegration {
  var loggedIn: Bool { get set }
}

extension FacebookIntegration {
  initlaizeFacebook() {
    Auth.auth().addStateDidChangeListener { (auth, user) in
      if (user != nil) {
        /*If the user is already logged in, this code runs on application launch.
         Otherwise, it runs as soon as the user is logged into firebase*/
        loggedIn = true
        //Fetch the user's social graph
        self.fetchGraph(user: user!)
        
        // segue to tabbarcontroller
        if (self.delegate is FacebookLoginViewController) {
          self.mainSegue(vc:self.delegate as! FacebookLoginViewController)
        }
      } else {
        self.loggedIn = false
      }
    }
  }
  
  func loginToFacebook() {
    let loginManager = LoginManager()
    loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends]) { (loginResult) in
      switch loginResult {
      case .failed(let error):
        print(error)
      case .cancelled:
        print("User cancelled login.")
      case .success(_, _, let fbAccessToken):
        let credential = FacebookAuthProvider.credential(withAccessToken: fbAccessToken.authenticationToken)
        // login to firebase
        Auth.auth().signIn(with: credential, completion: { (user, error) in
          if let error = error {
            print("Firebase Auth Error \(error)")
          } else {
            self.fetchGraph(user: user!)
          }
          print("Logged in state \(self.loggedIn)!")
        })
      }
    }
  }
  
  func fetchGraph(user: User) {
    // create facebook graph request
    // If this assertion fails, try commenting it out, logging out, then uncommenting it and logging back in.
    // If it still fails, yell at BrannenGHH
    assert(AccessToken.current != nil)
    struct UserInfoRequest: GraphRequestProtocol {
      struct Response: GraphResponseProtocol {
        var name: String?
        var email: String?
        var id: String?
        init(rawResponse: Any?) {
          // Decode JSON from rawResponse into other properties here.
          guard let response = rawResponse as? Dictionary<String, Any> else {
            return
          }
          if let name = response["name"] as? String {
            self.name = name
          }
          
          if let id = response["id"] as? String {
            self.id = id
          }
          
          if let email = response["email"] as? String {
            self.email = email
          }
        }
      }
      
      var graphPath = "/me"
      var parameters: [String: Any]? = ["fields": "name, email, id"]
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
        let fbID = ref.child("fbID")
        let fbIDUpdate = ["\(response.id!)": "\(user.uid)"]
        fbID.updateChildValues(fbIDUpdate)
        let userRef = ref.child("users/\((user.uid))/")
        let userInfo = ["name": response.name!,
                        "email": response.email!]
        userRef.updateChildValues(userInfo)
      case .failed(let error):
        print("User Info Graph Request Failed: \(error)")
      }
    }
    connection.start()
  }
  
  func logoutOfFacebook() {
    let loginManager = LoginManager()
    loginManager.logOut()
    
    // TODO:// firebase logout
    do {
      try Auth.auth().signOut()
    } catch let signOutError as NSError {
      print("Error signing out: \(signOutError)")
    }
    
    // TODO:// present loginvc
    let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FacebookLogin")
    vc.present(loginVC, animated: true, completion: nil)
  }
}
