//
//  TodoListItem.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class TodoListItem {
    private var _title: String
    private var _isChecked: Bool
    
    var title: String {
        get {
            return _title
        }
    }
    
    var isChecked: Bool {
        get {
            return _isChecked
        }
        
		set {
            _isChecked = newValue
        }
    }
    
    
    init(_ title: String) {
        _title = title
        _isChecked = false
    }
    
    init(_ title: String, _ isChecked: Bool) {
        _title = title
        _isChecked = isChecked
    }
    
    init(title: String, isChecked: Bool) {
        _title = title
        _isChecked = isChecked
    }
    
    public func equals(_ item: TodoListItem) -> Bool {
        if(item._isChecked == self._isChecked && item._title == self.title){
            return true
        }
        else {
            return false
        }
    }
}
