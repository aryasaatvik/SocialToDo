//
//  TodoListItem.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

struct Todo: ListElement, Codable {
  var identifier: String
  var name: String
  var isChecked: Bool

  var title: String {
    get {
      return name
    } set(value) {
      name = value
    }
  }

  init(title: String, identifier: String) {
    self.name = title
    self.identifier = identifier
    isChecked = false
  }

  init(title: String, identifier: String, isChecked: Bool) {
    self.name = title
    self.identifier = identifier
    self.isChecked = isChecked
  }

  init(title: String, identifier: String, time: Date, isChecked: Bool = false) {
    self.name = title
    self.identifier = identifier
    self.isChecked = isChecked
  }

  enum CodingKeys: String, CodingKey {
  	case identifier = "identifier"
  	case name = "title"
  	case isChecked = "isChecked"
  }
}
