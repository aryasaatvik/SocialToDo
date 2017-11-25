//
//  TodoList.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//


class TodoList:List<Todo>,Equatable {
    /*A TodoList wrapper so the actual implementation of the TodoList
    could be changed in the future without breaking everything*/
    //Using swift arrays to store the items for now
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
		super.init()
    }
    
    func getElement(id:String) -> Todo? {
        return getElement(similarTo:Todo("",id:id))
    }
    
    func remove(id:String) -> Int? {
        return remove(element:Todo("",id:id))
    }
    
	init(title: String, id: String, listItems:Todo...){
		self._title = title
		self._id = id
        super.init(listItems)
    }
    
	init(title: String, id: String, listItems:[Todo]){
		self._title = title
		self._id = id
        super.init(listItems)
    }
    
    static func ==(lhs: TodoList, rhs: TodoList) -> Bool {
        return (lhs.id == rhs.id)
    }
}
