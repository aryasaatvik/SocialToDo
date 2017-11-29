//
//  Database.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-28.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DatabaseAccess {
  var root: DatabaseReference { get }
}

extension DatabaseAccess {
  func upload<T:List>(directory:DatabaseReference, elements: T) {
    root.setValue(try? JSONEncoder().encode(elements))
  }

  func load(onLoad: @escaping (DataSnapshot) -> ()) {
    root.observe(.value, with: onLoad)
  }
}
