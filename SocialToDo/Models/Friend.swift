//
//  Friend.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

enum FriendRequestState: String, Codable {
  case notFriends = "false"
  case requestSent = "requestSent"
  case requestReceived = "requestReceived"
  case friends = "true"
}

struct Friend: ListElement, Codable {
  var name: String
  var identifier: String
  var isFriended: FriendRequestState

  init(name: String, identifier: String) {
    self.name = name
    self.identifier = identifier
    isFriended = FriendRequestState.notFriends
  }

  init(name: String, identifier: String, isFriended: FriendRequestState) {
    self.name = name
    self.identifier = identifier
    self.isFriended = isFriended
  }

  init(name: String, identifier: String, isFriended: String) {
    self.name = name
    self.identifier = identifier
    self.isFriended = FriendRequestState(rawValue: isFriended) ?? .notFriends
  }
  
  enum CodingKeys: String, CodingKey {
  	case name = "name"
  	case identifier = "identifier"
  	case isFriended = "isFriended"
  }
}
