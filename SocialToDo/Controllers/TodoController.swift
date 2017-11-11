//
//  TodoController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class TodoController:NSObject,UITableViewDataSource {
    //var delegate: TodoControllerDelegate?
    var currentTodo: TodoList = TodoList(listItems:TodoListItem("Task One",false),TodoListItem("Task Two", true))
    override init(){
        super.init()
        //TODO: Load todoLists from storage
    }
    
    func addElement(items:TodoListItem...){
        currentTodo.add(listItems: items)
    }
    
    func removeElement(atIndex:Int){
        currentTodo.remove(atIndex: atIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentTodo.getElements().count+1)
        //At one point add one for the add entry UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row != currentTodo.getElements().count){
            //TODO: Design custom cell that allows a item to be both checked and removed
			let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem") as! todoItem
            cell.label!.text = currentTodo.getElementAt(atIndex: indexPath.row).title
            // initialize checkbox
            cell.checkbox.checkmarkStyle = .tick
            cell.checkbox.borderWidth = 4
            cell.checkbox.uncheckedBorderColor = .magenta
            cell.checkbox.checkedBorderColor = .green
            cell.checkbox.checkmarkColor = .green
            cell.checkbox.isChecked = currentTodo.getElementAt(atIndex: indexPath.row).isChecked
            cell.checkbox.valueChanged = { (value) in
                self.currentTodo.getElementAt(atIndex: indexPath.row).isChecked = value
            }
            return cell
        } else {
            //TDOD: Design custom cell that allows a button to be added
            let addItemCell = UITableViewCell(style:.value1, reuseIdentifier: nil)
            addItemCell.textLabel!.text = "PUT (ADD NEW ITEM) BUTTON HERE"
            return addItemCell
        }
    }
}
