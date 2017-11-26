//
//  FriendTodoLists.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/25/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class FriendTodoListsViewController: UIViewController, FBControllerDelegate, UITableViewDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var friendsTodoListsControl: FriendTodoListsController?
	var fbControl:FBController?
	var todoControl: TodoListController?
	var todoList: TodoList?
	
	@IBOutlet weak var friendName: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()
		
		tableView.dataSource = friendsTodoListsControl
		tableView.delegate = self
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func handleBackButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func promptFacebookLogin() {
		let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
		present(facebookLoginViewController!, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoList = friendsTodoListsControl?.list.getElement(at: indexPath.row)
		let title = todoList?.title
		let id = todoList?.id
		let friendID = friendsTodoListsControl?.friendID
		print("TABLE VIEW ROW SELECTED")
		print("TODOLIST REQUESTED: \(title), \(id)")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "friendTodoListVC") as? FriendTodoListViewController {
			destinationVC.friendTodoControl = FriendTodoListController(friendID: friendID!, todoList!)
			destinationVC.friendTodoControl?.delegate = destinationVC
			self.present(destinationVC, animated: true, completion: nil)
		}
	}
}

extension FriendTodoListsViewController: FriendTodoListsDelegate {
	func reloadTableView() {
		self.tableView.reloadData()
	}
	func beginUpdates() {
		self.tableView.beginUpdates()
	}
	func endUpdates() {
		self.tableView.endUpdates()
	}
	func insertRow(indexPath: IndexPath) {
		self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	}
	func deleteRow(indexPath: IndexPath) {
		self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	}
}
