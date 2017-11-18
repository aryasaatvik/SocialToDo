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
    //var delegate: TodoControllerDelegate?
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
		ref.child("users/\(userID)/privateLists/0/tasks").observeSingleEvent(of: .value, with: { (snapshot) in
			let tasks = snapshot.value as! [String]
			for i in (0..<self.currentTodo.getElements().count){
				if(tasks[i] != self.currentTodo.getElementAt(atIndex: i).title){
					let todo = TodoListItem(tasks[i])
					self.currentTodo.add(listItems: [todo])
				}
			}
			for i in (self.currentTodo.getElements().count..<tasks.count){
				let todo = TodoListItem(tasks[i])
				self.currentTodo.add(listItems: [todo])
			}
		}) { (error) in
			print(error.localizedDescription)
		}
	}
	
    func addElement(items:TodoListItem...){
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let tasksRef = ref.child("users/\(userID)/privateLists/0/tasks/")
		
		for item in items {
			let key = tasksRef.child("\(currentTodo.getElements().count)").key
			let childUpdate = ["users/\(userID)/privateLists/0/tasks/\(key)": item.title]
			ref.updateChildValues(childUpdate)
			currentTodo.add(listItems: [item])
		}
    }
    
    func removeElement(atIndex:Int){
        currentTodo.remove(atIndex: atIndex)
    }
	
	@objc func changeValues(checkbox: Checkbox) {
		if(checkbox.isSelected == true){
			checkbox.isSelected = false
			let todo = currentTodo.getElementAt(atIndex: checkbox.index)
			todo.isChecked = false
		}
		else {
			checkbox.isSelected = true
			let todo = currentTodo.getElementAt(atIndex: checkbox.index)
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
		return cell
    }
}
