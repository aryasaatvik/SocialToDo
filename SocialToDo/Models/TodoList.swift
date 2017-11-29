//
//  TodoList.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-10.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

class TodoList: List, ListElement, AccessPermissions, Codable {
  typealias Item = Todo
  var list: [Todo]
  var accessList: FriendList = FriendList()
  var name: String
  var identifier: String
  var title: String {
    get {
      return name
    } set(value) {
      name = value
    }
  }
  
  init(_ title: String, identifier: String) {
    //Returns an empty todolist
    self.name = title
    self.identifier = identifier
    list = []
  }
  
  init(title: String, identifier: String, listItems: Todo...) {
    self.name = title
    self.identifier = identifier
    list = listItems
  }
  
  init(title: String, identifier: String, listItems: [Todo]) {
    self.name = title
    self.identifier = identifier
    list = listItems
  }
  
  enum CodingKeys: String, CodingKey {
    case name = "title"
    case identifier = "identifier"
    case list = "todolist"
  }
}
