//
//  TLList.swift
//  TodoList List - List of Todo Lists
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class TLList:List {
    typealias Item = TodoList
    var list:[TodoList]
    
    init(){
        list = []
    }
    
	init(listItems:TodoList...){
		list = listItems
	}
	
	init(listItems:[TodoList]){
		list = listItems
	}
}

