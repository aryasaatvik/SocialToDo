//
//  TLListController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol TLListControllerDelegate {
	func reloadTableView()
}

class TLListController: NSObject, UITableViewDataSource {
	var delegate: TLListControllerDelegate?
	var list: TLList = TLList()
	var todoLists: Int
	var userID: String
	var ref: DatabaseReference!
	var todoListsRef: DatabaseReference!
	
	override init() {
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
		todoListsRef = ref.child("users/\(userID)/privateLists/")
		todoLists = 0
		super.init()
		fetchTodoLists()
	}
	
	func fetchTodoLists() {
		todoListsRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let lists = snapshot.value as? [NSDictionary] {
				print(lists)
				for list in lists {
					let title = "\(list["name"]!)"
					self.list.add(list: TodoList(title, id: self.todoLists))
					self.todoLists += 1
				}
			}
		}) { (error) in
			print(error.localizedDescription)
		}
		self.delegate?.reloadTableView()
	}
	
	func addTodoList(list: TodoList) {

	}
	
	func removeTodoList() {
	
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.getElements().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "list") as! ListCell
		let todoList = list.getElementAt(atIndex: indexPath.row)
		cell.title!.text = todoList.getTitle()
		return cell
	}
	
	
}
