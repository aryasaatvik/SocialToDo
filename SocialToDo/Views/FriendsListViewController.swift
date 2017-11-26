//
//  HomeViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController, FBControllerDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var friendsListControl: FriendsListController?

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		friendsListControl = appDelegate.friendsListControl
		friendsListControl?.delegate = self
		
		tableView.dataSource = friendsListControl
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func promptFacebookLogin() {
        let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
        present(facebookLoginViewController!, animated: true, completion: nil)
    }
}

extension FriendsListViewController: FriendsListControllerDelegate {
	func reloadTableView() {
		self.tableView.reloadData()
	}
}
