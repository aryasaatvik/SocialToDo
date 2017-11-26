//
//  TodoListItem.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

class Todo:Equatable {
    let title: String
    var id: String
    var isChecked: Bool
    var dueDate: Date?

    init(_ title: String, id: String) {
        self.title = title
        self.id = id
        self.isChecked = false
    }
    
    init(title: String, id: String, isChecked: Bool) {
        self.title = title
        self.id = id
        self.isChecked = isChecked
    }
    
    init(title: String, id: String, time:Date, isChecked: Bool = false) {
        self.title = title
        self.id = id
        self.isChecked = isChecked
        self.dueDate = time
    }
    
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return (lhs.id == rhs.id)
    }
    
}
