//
//  TodoList.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//


class TodoList {
    /*A TodoList wrapper so the actual implementation of the TodoList
    could be changed in the future without breaking everything*/
    //Using swift arrays to store the items for now
    private var todoList:[Todo]
	private var _title: String
	private var _id: String
	
	var title: String {
		get {
			return _title
		}
	}
	
	var id: String {
		get {
			return _id
		}
	}
	
	
	
	init(_ title: String, id: String){
        //Returns an empty todolist
		self._title = title
		self._id = id
		todoList = [Todo]()
    }
    
	init(title: String, id: String, listItems:Todo...){
		self._title = title
		self._id = id
        todoList = listItems
    }
    
	init(title: String, id: String, listItems:[Todo]){
		self._title = title
		self._id = id
        todoList = listItems
    }
    
    public func add(todo: Todo){
		todoList.append(todo)
    }
    
    /*Warning and TODO: If one element is removed, Swift will automatically
    reindex the others, so further removes should not be permitted
    until MyListsViewController.tableView recieves new, properly
    indexed elements*/
    
    public func remove(atIndex:Int){
        todoList.remove(at:atIndex)
    }
	
	public func remove(id: String) -> Int? {
		for (index, todo) in todoList.enumerated() {
			if(todo.id == id) {
				todoList.remove(at: index)
				return index
			}
		}
		return nil
	}
	
	public func empty() {
		todoList = []
	}
	
    
    public func getElement(atIndex:Int) -> Todo{
        return todoList[atIndex]
    }
	
	public func getElement(withID: String) -> Todo?{
		for todo in todoList {
			if(todo.id == withID) {
				return todo
			}
		}
		return nil
	}

    /* These functions search the array, they are
    O(n), do not use these unless there is some situation
    in which an element needs to be removed and the index
    is forgotten. */
    
    public func remove(listItems:[Todo]){
        for item in listItems {
            var i = 0
            while (item.equals(todoList[i])){
                i += 1
            }
            if (i < listItems.count){
                remove(atIndex: i)
            }
        }
    }
    
    // This should always return an array of strings
    public func getElements() -> [Todo] {
        return todoList
    }
}
