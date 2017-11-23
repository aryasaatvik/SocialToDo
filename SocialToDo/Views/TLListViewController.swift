//
//  TLListViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit


class TLListViewController: UIViewController, FBControllerDelegate, UITableViewDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var listControl:TLListController?
	var fbControl:FBController?
	var todoControl: TodoListController?
	var todoList: TodoList?
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		listControl = appDelegate.listControl
		listControl?.delegate = self
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()
		
		tableView.dataSource = listControl
		tableView.delegate = self
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	func promptFacebookLogin() {
		let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
		present(facebookLoginViewController!, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoList = listControl!.list.getElementAt(atIndex: indexPath.row)
		let title = todoList!.getTitle()
		let id = todoList!.getId()
		print("TABLE VIEW ROW SELECTED")
		print("TODOLIST REQUESTED: \(title), \(id)")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "todoListVC") as? TodoListViewController {
			appDelegate.todoControl = TodoListController()
			todoControl = appDelegate.todoControl
			destinationVC.todoControl = todoControl
			destinationVC.todoControl?.delegate = destinationVC
			destinationVC.todoControl?.todoList = todoList!
			destinationVC.todoControl?.fetchMyList()
			self.present(destinationVC, animated: true, completion: nil)
		}
	}
	
	
}


extension TLListViewController: TLListControllerDelegate {
	func reloadTableView() {
		self.tableView.reloadData()
	}
}
