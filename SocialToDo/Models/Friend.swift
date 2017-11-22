//
//  Friend.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class Friend {
	private var _name: String
	private var _fbid: String
//	private var _email: String
	private var _isFriended: Bool
	
	var name: String {
		get {
			return _name
		}
		set {
			_name = newValue
		}
	}
	
	var fbid: String {
		get {
			return _fbid
		}
		set {
			_fbid = newValue
		}
	}
	
//	var email: String {
//		get {
//			return _email
//		}
//		set {
//			_email = newValue
//		}
//	}
	
	var isFriended: Bool {
		get {
			return _isFriended
		}
		set {
			_isFriended = newValue
		}
	}
	
	init(_ name: String, _ fbid: String) {
		_name = name
		_fbid = fbid
		_isFriended = false
	}
	
	init(_ name: String, _ fbid: String, _ isFriended: Bool) {
		_name = name
		_fbid = fbid
		_isFriended = isFriended
	}
	
	init(name: String, fbid: String, isFriended: Bool) {
		_name = name
		_fbid = fbid
		_isFriended = isFriended
	}
	
}
