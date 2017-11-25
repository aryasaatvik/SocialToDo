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
	func beginUpdates()
	func endUpdates()
	func insertRow(indexPath: IndexPath)
	func deleteRow(indexPath: IndexPath)

}

class TLListController: NSObject, UITableViewDataSource {
	var delegate: TLListControllerDelegate?
	var list: TLList = TLList()
	var userID: String
	var ref: DatabaseReference!
	var todoListsRef: DatabaseReference!
	
	override init() {
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
		todoListsRef = ref.child("privateLists/\(userID)/")
		super.init()
		listenForLists()
	}
	
	func listenForLists() {
		todoListsRef.observe(.childAdded) { (snapshot) -> Void in
			print("SNAPSHOT: \(snapshot)")
			
			if let todoList = snapshot.value as? NSDictionary {
				let listID = snapshot.key
				let title = "\(todoList["name"]!)"
				let newList = TodoList(title, id: listID)
				self.delegate?.beginUpdates()
				self.list.add(list: newList)
				self.delegate?.insertRow(indexPath: IndexPath(row: self.list.getElements().count - 1, section: 0))
				self.delegate?.endUpdates()
				
			}
		}
		
		todoListsRef.observe(.childRemoved) { (snapshot) -> Void in
			print("SNAPSHOT: \(snapshot)")
			let listID = snapshot.key
			self.delegate?.beginUpdates()
			let index = self.list.remove(id: listID)!
			self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
			self.delegate?.endUpdates()
		}
	}
	
	func addTodoList(title: String) {
		let listRef = todoListsRef.childByAutoId()
		let childUpdate = ["name": "\(title)"]
		listRef.updateChildValues(childUpdate)
	}
	
	@objc func removeTodoList(trash: Trash) {
		todoListsRef.child("\(trash.id)").removeValue()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.getElements().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "list") as! ListCell
		let todoList = list.getElementAt(atIndex: indexPath.row)
		cell.title.text = todoList.title
		cell.trash.id = todoList.id
		cell.trash.addTarget(self, action: #selector(removeTodoList(trash:)), for: .touchUpInside)
		return cell
	}
	
}
