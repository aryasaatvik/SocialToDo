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

typealias TodoListControllerDelegate = ListControllerDelegate

class TodoListController: ListController<TodoList> {
    //If the user selects a UITableView box to edit the due date for an object, it is stored here
	let vc: String
	init(_ todoList:TodoList, path: String, userID: String, vc: String){
		self.vc = vc
		super.init(list:todoList, path: path, userID: userID, listID: todoList.id, root: getDatabase ,newListInserted: newListInserted, newListRemoved: newListRemoved)
    }
    
	func getDatabase(_ path: String, _ userID: String, _ listID: String) -> DatabaseReference {
		return Database.database().reference().child("\(path)/\(userID)/\(listID)/tasks")
    }
    
    func newListInserted(snapshot:DataSnapshot){
        print("SNAPSHOT: \(snapshot)")
        
        if let todo = snapshot.value as? NSDictionary {
            let todoID = snapshot.key
            let title = "\(todo["title"]!)"
            let checked = "\(todo["checked"] ?? "false")" == "true"
            let todo = Todo(title: title, id: todoID, isChecked: checked)
            self.delegate?.beginUpdates()
            self.list.add(item: todo)
            self.delegate?.insertRow(indexPath: IndexPath(row: self.list.getElements().count - 1, section: 0))
            self.delegate?.endUpdates()
        }
    }
    
    func newListRemoved(snapshot:DataSnapshot){
        print(snapshot)
        let todoID = snapshot.key
        self.delegate?.beginUpdates()
        let index = self.list.remove(id: todoID)!
        self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
        self.delegate?.endUpdates()
    }
	
	@objc func changeValues(checkbox: Checkbox) {
		var todo = list.getElement(id: checkbox.id)!
		let todoRef = root.child("/\(todo.id)/")

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
    
    
    
    func allowDateEditing(_ cell:UITableViewCell){
        if let todoCell = cell as? TodoCell {
            //todoCell.
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (vc == "TodoList"){
			tableView.estimatedRowHeight = 75
			tableView.rowHeight = UITableViewAutomaticDimension
			let cell = tableView.dequeueReusableCell(withIdentifier: "todo") as! TodoCell
			cell.selectionStyle = .none
			let todo = list.getElement(at: indexPath.row)
			cell.label!.text = todo.title
			// initialize checkbox
			cell.checkbox.isSelected = todo.isChecked
			cell.checkbox.id = todo.id
			cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
			cell.trash.id = todo.id
			cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
			return cell
		}
		else if (vc == "FriendTodoList"){
			tableView.rowHeight = 75
			let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTodoListCell") as! FriendTodoListCell
			cell.selectionStyle = .none
			let todo = list.getElement(at: indexPath.row)
			cell.label!.text = todo.title
			// initialize checkbox
			cell.checkbox.isSelected = todo.isChecked
			cell.checkbox.id = todo.id
			cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
			cell.trash.id = todo.id
			cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
			return cell
		}
		else if (vc == "SharedTodoList"){
			tableView.estimatedRowHeight = 75
			tableView.rowHeight = UITableViewAutomaticDimension
			let cell = tableView.dequeueReusableCell(withIdentifier: "SharedTodoCell") as! SharedTodoCell
			cell.selectionStyle = .none
			let todo = list.getElement(at: indexPath.row)
			cell.label!.text = todo.title
			// initialize checkbox
			cell.checkbox.isSelected = todo.isChecked
			cell.checkbox.id = todo.id
			cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
			cell.trash.id = todo.id
			cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
			return cell
		}
		return UITableViewCell()
    }
}


