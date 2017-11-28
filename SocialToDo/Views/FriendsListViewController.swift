//
//  HomeViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController, FBControllerDelegate, UITableViewDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var friendsListControl: FriendsListController?

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		friendsListControl = appDelegate.friendsListControl
		friendsListControl?.delegate = self
		
		tableView.dataSource = friendsListControl
		tableView.delegate = self
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("DID SELECT ROW")
		let friend = friendsListControl?.friendList.getElement(at: indexPath.row)
		let friendID = friend?.id
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "friendTodoListsVC") as? FriendTodoListsViewController {
			destinationVC.friendsTodoListsControl = TLListController(path: "sharedLists", userID: friendID!, vc: "FriendTodoLists")
			destinationVC.friendsTodoListsControl?.delegate = destinationVC
			destinationVC.navigationItem.title = friend?.name
			self.navigationController?.pushViewController(destinationVC, animated: true)
		}
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
