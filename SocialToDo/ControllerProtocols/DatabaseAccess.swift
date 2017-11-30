//
//  Database.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-28.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol DatabaseAccess {
  var root: DatabaseReference { get }
}

extension DatabaseAccess {
  func upload<T:List>(elements: T) {
    let serializedElements = try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode(elements), options: []) as! [String : Any]
    if let itemId = elements.firebaseId {
      root.child("tests").child("\((Auth.auth().currentUser?.uid)!)").child(itemId).setValue(serializedElements)
    } else {
      root.child("tests").child("\((Auth.auth().currentUser?.uid)!)").childByAutoId().setValue(serializedElements)
    }
  }

  func load(onLoad: @escaping (DataSnapshot) -> ()) {
    root.observe(.value, with: onLoad)
  }
}
