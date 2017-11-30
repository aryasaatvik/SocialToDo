//
//  FriendsList.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class FriendList: List, Codable {
  var firebaseId: String?
  var list: [Friend]
  typealias Item = Friend

  init() {
    //Returns an empty list
    list = [Friend]()
  }

  init(_ listItems: Friend...) {
    list = listItems
  }

  init(_ listItems: [Friend]) {
    list = listItems
  }
}
