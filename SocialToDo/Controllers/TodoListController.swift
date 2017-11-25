//
//  TodoController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol TodoListControllerDelegate {
	func reloadTableView()
	func beginUpdates()
	func endUpdates()
	func insertRow(indexPath: IndexPath)
	func deleteRow(indexPath: IndexPath)

}

class TodoListController: NSObject, UITableViewDataSource {
    var delegate: TodoListControllerDelegate?
    let todoList: TodoList
	var userID: String
	var ref: DatabaseReference!
	var taskAddedObserver: DatabaseHandle!
	var taskRemovedObserver: DatabaseHandle!
	
	
    init(_ todoList:TodoList){
        self.todoList = todoList
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
        super.init()
    }
	
	func listenForTodos() {
		let tasksRef = ref.child("privateLists/\(userID)/\(todoList.id)/tasks/")
		taskAddedObserver = tasksRef.observe(.childAdded) { (snapshot) -> Void in
			print("SNAPSHOT: \(snapshot)")
			
			if let todo = snapshot.value as? NSDictionary {
				let todoID = snapshot.key
				let title = "\(todo["title"]!)"
				let checked = "\(todo["checked"] ?? "false")" == "true"
				let todo = Todo(title: title, id: todoID, isChecked: checked)
				self.delegate?.beginUpdates()
				self.todoList.add(todo: todo)
				self.delegate?.insertRow(indexPath: IndexPath(row: self.todoList.getElements().count - 1, section: 0))
				self.delegate?.endUpdates()
			}
		}
		
		taskRemovedObserver = tasksRef.observe(.childRemoved) { (snapshot) -> Void in
			print(snapshot)
			let todoID = snapshot.key
			self.delegate?.beginUpdates()
			let index = self.todoList.remove(id: todoID)!
			self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
			self.delegate?.endUpdates()
		}
		
		
	}
	
    func addElement(title:String){
		let todoRef = ref.child("privateLists/\(userID)/\(todoList.id)/tasks/").childByAutoId()
		let childUpdate = ["title": title,
		                   "checked": "false"]
		todoRef.updateChildValues(childUpdate)
    }
    
	@objc func removeElement(trash: Trash){
		let tasksRef = ref.child("privateLists/\(userID)/\(todoList.id)/tasks/")
		tasksRef.child("\(trash.id)").removeValue()
	}
	
	@objc func changeValues(checkbox: Checkbox) {
		let todo = todoList.getElement(withID: checkbox.id)!
		let todoRef = ref.child("privateLists/\(userID)/\(todoList.id)/tasks/\(todo.id)/")

		if(checkbox.isSelected){
			checkbox.isSelected = false
			let childUpdate = ["checked": "false"]
			todoRef.updateChildValues(childUpdate)
			todo.isChecked = false
			
		}
		else {
			checkbox.isSelected = true
			let childUpdate = ["checked": "true"]
			todoRef.updateChildValues(childUpdate)
			todo.isChecked = true
		}
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.getElements().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "todo") as! TodoCell
		cell.selectionStyle = .none
		let todo = todoList.getElement(atIndex: indexPath.row)
		cell.label!.text = todo.title
		// initialize checkbox
		cell.checkbox.isSelected = todo.isChecked
		cell.checkbox.id = todo.id
		cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
		cell.trash.id = todo.id
		cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
		return cell
    }
}


