//
//  TLList.swift
//  TodoList List - List of Todo Lists
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class TLList:List<TodoList> {
    
	init(listItems:TodoList...){
		super.init(listItems)
	}
	
	init(listItems:[TodoList]){
		super.init(listItems)
	}
    
    /*TODO: Write protocol for an item that has an ID and a title,
    and that is equitable*/
    func remove(id:String) -> Int? {
        return remove(element:TodoList("",id:id))
    }
}

