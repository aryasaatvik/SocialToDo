//
//  TodoList.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//


class TodoList:List,ListElement {
    typealias Item = Todo
    var list: [Todo]
    var name:String
	var id: String
    var title: String {
        get {
            return name
        } set(value) {
            name = value
        }
    }
    
	init(_ title: String, id: String){
        //Returns an empty todolist
		self.name = title
		self.id = id
        list = []
    }
    
    
	init(title: String, id: String, listItems:Todo...){
		self.name = title
		self.id = id
        list = listItems
    }
    
	init(title: String, id: String, listItems:[Todo]){
		self.name = title
		self.id = id
        list = listItems
    }
}
