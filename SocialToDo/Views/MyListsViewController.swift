//
//  MyListsViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class MyListsViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var todoControl:TodoController?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addTodoField: UITextField!
	@IBOutlet weak var addTodoButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        todoControl = appDelegate.todoControl
		todoControl?.delegate = self
        tableView.dataSource = todoControl
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func handleAddTodoButton(_ sender: Any) {
		let todoText = addTodoField.text!
		todoControl?.addElement(item: TodoListItem(todoText))
		tableView.reloadData()
	}
}

extension MyListsViewController: TodoControllerDelegate {
	func reloadTableView() {
		print("RELOAD TABLE VIEW")
		self.tableView.reloadData()
	}
}

