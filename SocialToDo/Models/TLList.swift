//
//  TLList.swift
//  TodoList List - List of Todo Lists
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class TLList {
	private var list: [TodoList]
	
	init(){
		//Returns an empty todolist
		list = [TodoList]()
	}
	
	init(listItems:TodoList...){
		list = listItems
	}
	
	init(listItems:[TodoList]){
		list = listItems
	}
	
	public func add(list: TodoList){
		self.list.append(list)
	}
	
	/*Warning and TODO: If one element is removed, Swift will automatically
	reindex the others, so further removes should not be permitted
	until MyListsViewController.tableView recieves new, properly
	indexed elements*/
	
	public func remove(atIndex:Int){
		list.remove(at:atIndex)
	}
	
	
	public func getElementAt(atIndex:Int) -> TodoList{
		return list[atIndex]
	}
		
	// This should always return an array of strings
	public func getElements() -> [TodoList] {
		return list
	}
}

