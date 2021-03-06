//
//  FriendsViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, FBControllerDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var friendsControl: FriendsController?
	var fbControl:FBController?
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		friendsControl = appDelegate.friendsControl
		friendsControl?.delegate = self
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()
		
		tableView.dataSource = friendsControl
		

		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    func promptFacebookLogin() {
        let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "Facebook Login")
        present(facebookLoginViewController!, animated: true, completion: nil)
    }
}

extension FriendsViewController: FriendsControllerDelegate {
	func reloadTableView() {
		self.tableView.reloadData()
	}
}

