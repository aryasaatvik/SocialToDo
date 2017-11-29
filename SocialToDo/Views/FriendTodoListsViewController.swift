//
//  FriendTodoLists.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/25/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class FriendTodoListsViewController: UIViewController, UITableViewDelegate {
	@IBOutlet weak var friendName: UILabel!
	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func handleBackButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	/*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoList = friendsTodoListsControl?.list.getElement(at: indexPath.row)
		let title = todoList?.title
		let id = todoList?.id
		let friendID = friendsTodoListsControl?.userID
		print("TABLE VIEW ROW SELECTED")
		print("TODOLIST REQUESTED: \(title), \(id)")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "friendTodoListVC") as? FriendTodoListViewController {
			destinationVC.friendTodoControl = TodoListController(todoList!, path: "sharedLists", userID: friendID!, vc: "FriendTodoList") //FriendTodoListController(friendID: friendID!, todoList!)
			destinationVC.friendTodoControl?.delegate = destinationVC
			self.present(destinationVC, animated: true, completion: nil)
		}
	}*/
}
