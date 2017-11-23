//
//  FriendsList.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class FriendList {
	private var friendList:[Friend]
	
	init() {
		friendList = [Friend]()
	}
	
	init(friends: Friend...) {
		friendList = friends
	}
	
	init(friends: [Friend]) {
		friendList = friends
	}
	
	public func add(friends: [Friend]) {
		for friend in friends {
			friendList.append(friend)
		}
	}
	
	public func getElements() -> [Friend] {
		return friendList
	}
	
	public func getElementAt(atIndex:Int) -> Friend{
		return friendList[atIndex]
	}
	
}
