//
//  TodoController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoController:NSObject,UITableViewDataSource {
	var delegate: TodoControllerDelegate?
    var currentTodo: TodoList = TodoList()
	// TODO: Firebase Authentication
	let userID = "F3OWhPHczIUehu7BV7C0mDVCO8Q2"
	
    override init(){
        super.init()
        //TODO: Load todoLists from storage
		fetchMyList()
    }
	
	func fetchMyList(){
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
		tasksRef.observeSingleEvent(of: .value, with: { (snapshot) in
			let tasks = snapshot.value as! [[String: String]]
			for task in tasks {
				let title = task["title"]!
				let checked = task["checked"]! == "true"
				let todo = TodoListItem(title, checked)
				self.currentTodo.add(listItems: [todo])
			}
		}) { (error) in
			print(error.localizedDescription)
		}
		self.delegate?.reloadTableView()
	}
	
    func addElement(item:TodoListItem){
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
		let childUpdate = ["\(currentTodo.getElements().count)/title": item.title,
		                   "\(currentTodo.getElements().count)/checked": "false"]
		tasksRef.updateChildValues(childUpdate)
		currentTodo.add(listItems: [item])
    }
    
	@objc func removeElement(trash: Trash){
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
		tasksRef.child("\(trash.index)").removeValue()
		currentTodo.remove(atIndex: trash.index)
		self.delegate?.reloadTableView()
	}
	
	@objc func changeValues(checkbox: Checkbox) {
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
		
		if(checkbox.isSelected == true){
			checkbox.isSelected = false
			let todo = currentTodo.getElementAt(atIndex: checkbox.index)
			let childUpdate = ["\(checkbox.index)/checked": "false"]
			tasksRef.updateChildValues(childUpdate)
			todo.isChecked = false
			
		}
		else {
			checkbox.isSelected = true
			let todo = currentTodo.getElementAt(atIndex: checkbox.index)
			let childUpdate = ["\(checkbox.index)/checked": "true"]
			tasksRef.updateChildValues(childUpdate)
			todo.isChecked = true
		}
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentTodo.getElements().count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem") as! todoItem
		cell.selectionStyle = .none
		let todo = currentTodo.getElementAt(atIndex: indexPath.row)
		cell.label!.text = todo.title
		// initialize checkbox
		cell.checkbox.isSelected = todo.isChecked
		cell.checkbox.index = indexPath.row
		cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
		cell.trash.index = indexPath.row
		cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
		return cell
    }
}

protocol TodoControllerDelegate {
	func reloadTableView()
}
