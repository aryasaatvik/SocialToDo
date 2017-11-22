//
//  FriendsList.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class FriendsList {
	private var friendsList:[Friend]
	
	init() {
		friendsList = [Friend]()
	}
	
	init(friends: Friend...) {
		friendsList = friends
	}
	
	init(friends: [Friend]) {
		friendsList = friends
	}
	
	public func add(friends: [Friend]) {
		for friend in friends {
			friendsList.append(friend)
		}
	}
	
	public func getElements() -> [Friend] {
		return friendsList
	}
	
	public func getElementAt(atIndex:Int) -> Friend{
		return friendsList[atIndex]
	}
	
}
