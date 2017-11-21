//
//  FacebookLoginViewController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-18.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FacebookLogin

class FacebookLoginViewController: UIViewController {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fbControl:FBController?
	
	@IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        fbControl = appDelegate.fbControl
	
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
	@IBAction func handleLoginButton(_ sender: Any) {
		fbControl?.login(vc: self)
		if (fbControl?.loggedIn)! {
			if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController {
				present(tabBarVC, animated: true, completion: nil)
			}
		}
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
