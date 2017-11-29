//
//  FacebookLoginViewController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FacebookLogin

class FacebookLoginViewController{

    @IBAction func backPress(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
    }

    @IBAction func handleLoginButton(_ sender: Any) {
        //If the application is already logged-in and the button happens to be pressed, segues instead
        /*if (checkState()) {
            fbControl?.login()
        }*/
    }
}
