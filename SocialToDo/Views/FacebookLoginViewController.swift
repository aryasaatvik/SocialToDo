//
//  FacebookLoginViewController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FacebookLogin

class FacebookLoginViewController: UIViewController, FBControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fbControl:FBController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbControl = appDelegate.fbControl
        fbControl?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleLoginButton(_ sender: Any) {
        //If the application is already logged-in and the button happens to be pressed, segues instead
        if (checkState()){
            fbControl?.login()
        }
    }
    
    func checkState() -> Bool{
        if (fbControl!.loggedIn){
            fbControl!.mainSegue(vc:self)
            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
