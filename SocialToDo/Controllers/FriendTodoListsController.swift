//
//  FriendTodoListsController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/25/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

typealias FriendTodoListsDelegate = ListControllerDelegate

class FriendTodoListsController: ListController<TodoList, TLList> {
	var friendID: String
	init(friendID: String) {
		self.friendID = friendID
		super.init(list: TLList(), listID: "", userID: friendID, root: getDatabase, newListInserted: newListInserted, newListRemoved: newListRemoved)
	}
	
	func getDatabase(_ userID: String, _ id: String) -> DatabaseReference {
		return Database.database().reference().child("sharedLists/\(userID)")
	}
	
	func newListInserted(snapshot: DataSnapshot) {
		if let todoList = snapshot.value as? NSDictionary {
			let listID = snapshot.key
			let title = "\(todoList["name"]!)"
			let newList = TodoList(title, id: listID)
			self.delegate?.beginUpdates()
			self.list.add(item: newList)
			self.delegate?.insertRow(indexPath: IndexPath(row: self.list.getElements().count - 1, section: 0))
			self.delegate?.endUpdates()
		}
	}
	
	func newListRemoved(snapshot: DataSnapshot) {
		let listID = snapshot.key
		self.delegate?.beginUpdates()
		let index = self.list.remove(id: listID)!
		self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
		self.delegate?.endUpdates()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTodoListsCell") as! FriendTodoListsCell
		let todoList = list.getElement(at: indexPath.row)
		cell.name.text = todoList.title
		return cell
	}
}
