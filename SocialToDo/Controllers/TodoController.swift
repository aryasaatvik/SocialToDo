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
    var currentTodo: TodoList = TodoList(listItems:TodoListItem("Task One",false),TodoListItem("Task Two", true))
    override init(){
        super.init()
        //TODO: Load todoLists from storage
    }
	
	func fetchMyList(){
		var ref:DatabaseReference!
		ref = Database.database().reference()
		let userID = "F3OWhPHczIUehu7BV7C0mDVCO8Q2" // TODO: Firebase Authentication
		ref.child("users").child("\(userID)/privateLists").observeSingleEvent(of: .value, with: { (snapshot) in
			let lists = snapshot.value as! [NSDictionary]
			print(lists)
			for list in lists {
				let tasks = list["tasks"] as! NSArray
				print(tasks)
				for task in tasks {
					let todo = TodoListItem(task as! String)
					self.currentTodo.add(listItems: [todo])
				}
				
			}
			
		}) { (error) in
			print(error.localizedDescription)
		}


	}
	
    func addElement(items:TodoListItem...){
        currentTodo.add(listItems: items)
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
