//
//  TodoListItem.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

struct Todo:ListElement {
    var id:String
    var name:String
    var isChecked:Bool
    //var dueDate:time
    //For compatability reasons
    var title:String {
        get {
            return name
        } set(value) {
            name = value
        }
    }
    
    
    init(_ title: String, id: String) {
        self.name = title
        self.id = id
        isChecked = false
    }
    
    init(title: String, id: String, isChecked: Bool) {
        self.name = title
        self.id = id
        self.isChecked = isChecked
    }
    
    init(title: String, id: String, time:Date, isChecked: Bool = false) {
        self.name = title
        self.id = id
        self.isChecked = isChecked
        //self.dueDate = time
    }
}
