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
    var todoList: TodoList
	var userID: String
	var ref: DatabaseReference!
	
	
	override init(){
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
		todoList = TodoList("Todo List", id: "0")
        super.init()
    }
	
	func fetchMyList(){
		todoList.empty()
		let dispatchGroup = DispatchGroup()
		let tasksRef = ref.child("users/\(userID)/privateLists/\(todoList.id)/tasks/")
		dispatchGroup.enter()
		tasksRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let tasks = snapshot.value as? [NSDictionary]{
				for task in tasks {
					let title = "\(task["title"]!)"
					let id = "\(task.allKeys[0])"
					let checked = "\(task["checked"]!)" == "true"
					let todo = Todo(title: title, id: id, isChecked: checked)
					self.todoList.add(todo: todo)
				}
			}
			dispatchGroup.leave()
		}) { (error) in
			print(error.localizedDescription)
		}
		
		dispatchGroup.notify(queue: .main) {
			self.delegate?.reloadTableView()
		}
	}
	
	func listenForTodos() {
		let tasksRef = ref.child("users/\(userID)/privateLists/\(todoList.id)/tasks/")
		tasksRef.observe(.childAdded) { (snapshot) -> Void in
			print("SNAPSHOT: \(snapshot)")
			
			if let todo = snapshot.value as? NSDictionary {
				let todoID = snapshot.key
				let title = "\(todo["title"]!)"
				let todo = Todo(title, id: todoID)
				self.delegate?.beginUpdates()
				self.todoList.add(todo: todo)
				self.delegate?.insertRow(indexPath: IndexPath(row: self.todoList.getElements().count - 1, section: 0))
				self.delegate?.endUpdates()
			}
		}
		
		tasksRef.observe(.childRemoved) { (snapshot) -> Void in
			print(snapshot)
			let todoID = snapshot.key
			self.delegate?.beginUpdates()
			let index = self.todoList.remove(id: todoID)!
			self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
			self.delegate?.endUpdates()
		}
	}
	
    func addElement(title:String){
		let todoRef = ref.child("users/\(userID)/privateLists/\(todoList.id)/tasks/").childByAutoId()
		let childUpdate = ["title": title,
		                   "checked": "false"]
		todoRef.updateChildValues(childUpdate)
    }
    
	@objc func removeElement(trash: Trash){
		let tasksRef = ref.child("users/\(userID)/privateLists/\(todoList.id)/tasks/")
		tasksRef.child("\(trash.index)").removeValue()
	}
	
	@objc func changeValues(checkbox: Checkbox) {
		let tasksRef = ref.child("users/\(userID)/privateLists/\(todoList.id)/tasks/")

		if(checkbox.isSelected == true){
			checkbox.isSelected = false
			let todo = todoList.getElement(withID: checkbox.index)!
			let childUpdate = ["\(todo.id)/checked": "false"]
			tasksRef.updateChildValues(childUpdate)
			todo.isChecked = false
			
		}
		else {
			checkbox.isSelected = true
			let todo = todoList.getElement(withID: checkbox.index)!
			let childUpdate = ["\(todo.id)/checked": "true"]
			tasksRef.updateChildValues(childUpdate)
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
		cell.checkbox.index = todo.id
		cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
		cell.trash.index = todo.id
		cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
		return cell
    }
}


