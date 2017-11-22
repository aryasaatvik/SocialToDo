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

protocol TodoControllerDelegate {
	func reloadTableView()
}

class TodoController: NSObject, UITableViewDataSource {
	var delegate: TodoControllerDelegate?
    var todoList: TodoList = TodoList()
	var userID: String
	var ref: DatabaseReference!
	var tasksRef: DatabaseReference!
	
    override init(){
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
		tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
        super.init()
        //TODO: Load todoLists from storage
		fetchMyList()
    }
	
    func fetchMyList(){
		tasksRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let tasks = snapshot.value as? [[String: String]]{
				for task in tasks {
					let title = task["title"]!
					let checked = task["checked"]! == "true"
					let todo = Todo(title, checked)
					self.todoList.add(listItems: [todo])
				}
			}
		}) { (error) in
			print(error.localizedDescription)
		}
		self.delegate?.reloadTableView()
	}
	
    func addElement(item:Todo){
		let childUpdate = ["\(todoList.getElements().count)/title": item.title,
		                   "\(todoList.getElements().count)/checked": "false"]
		tasksRef.updateChildValues(childUpdate)
		todoList.add(listItems: [item])
    }
    
	@objc func removeElement(trash: Trash){
		tasksRef.child("\(trash.index)").removeValue()
		todoList.remove(atIndex: trash.index)
		self.delegate?.reloadTableView()
	}
	
	@objc func changeValues(checkbox: Checkbox) {
		if(checkbox.isSelected == true){
			checkbox.isSelected = false
			let todo = todoList.getElementAt(atIndex: checkbox.index)
			let childUpdate = ["\(checkbox.index)/checked": "false"]
			tasksRef.updateChildValues(childUpdate)
			todo.isChecked = false
			
		}
		else {
			checkbox.isSelected = true
			let todo = todoList.getElementAt(atIndex: checkbox.index)
			let childUpdate = ["\(checkbox.index)/checked": "true"]
			tasksRef.updateChildValues(childUpdate)
			todo.isChecked = true
		}
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (todoList.getElements().count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem") as! TodoCell
		cell.selectionStyle = .none
		let todo = todoList.getElementAt(atIndex: indexPath.row)
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


