//
//  ListElement.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-26.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

protocol ListElement: Equatable, Codable {
  var identifier: String { get }
  var name: String { get }
}

extension ListElement {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
