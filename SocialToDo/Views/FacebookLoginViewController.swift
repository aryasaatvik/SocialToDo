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

    override func viewDidLoad() {
        super.viewDidLoad()
        fbControl = appDelegate.fbControl
        let loginButton = LoginButton(readPermissions: [.userFriends,.publicProfile])
        loginButton.center = view.center
        loginButton.delegate = fbControl
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
