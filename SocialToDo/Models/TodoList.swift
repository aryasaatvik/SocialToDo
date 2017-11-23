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
	private var title: String
	private var id: Int
	
	init(_ title: String, id: Int){
        //Returns an empty todolist
		self.title = title
		self.id = id
		todoList = [Todo]()
    }
    
	init(title: String, id: Int, listItems:Todo...){
		self.title = title
		self.id = id
        todoList = listItems
    }
    
	init(title: String, id: Int, listItems:[Todo]){
		self.title = title
		self.id = id
        todoList = listItems
    }
    
    public func add(listItems:[Todo]){
        for listItem in listItems {
            todoList.append(listItem)
        }
    }
    
    /*Warning and TODO: If one element is removed, Swift will automatically
    reindex the others, so further removes should not be permitted
    until MyListsViewController.tableView recieves new, properly
    indexed elements*/
    
    public func remove(atIndex:Int){
        todoList.remove(at:atIndex)
    }
	
	public func empty() {
		todoList = []
	}
	
    
    public func getElementAt(atIndex:Int) -> Todo{
        return todoList[atIndex]
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
	
	public func getTitle() -> String {
		return self.title
	}
	
	public func getId() -> Int {
		return self.id
	}
}
