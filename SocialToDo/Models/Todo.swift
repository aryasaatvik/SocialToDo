//
//  TodoListItem.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class Todo {
    private var _title: String
	private var _id: String
    private var _isChecked: Bool
    
    var title: String {
        get {
            return _title
        }
    }
	
	var id: String {
		get {
			return _id
		}
		set {
			_id = newValue
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
    
    
	init(_ title: String, id: String) {
        _title = title
		_id = id
        _isChecked = false
    }
    
    init(title: String, id: String, isChecked: Bool) {
        _title = title
		_id = id
        _isChecked = isChecked
    }
    
    public func equals(_ item: Todo) -> Bool {
        if(item._isChecked == self._isChecked && item._title == self.title){
            return true
        }
        else {
            return false
        }
    }
}
