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
    var currentTodo: TodoList = TodoList(listItems:"Task One","Task Two")
    override init(){
        super.init()
        //TODO: Load todoLists from storage
    }
    
    func addElement(items:TodoList.TodoListItem...){
        currentTodo.add(listItems: items)
    }
    
    func removeElement(atIndex:Int){
        currentTodo.remove(atIndex: atIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTodo.getElements().count
        //At one point add one for the add entry UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TodoItemTableViewCell(//TODO:todo)
    }
}
