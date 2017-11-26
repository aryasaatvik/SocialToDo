//
//  ListElement.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-26.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

protocol ListElement:Equatable {
    var id:String { get }
    var name:String { get }
}

extension ListElement {
    static func ==(lhs:Self,rhs:Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct BasicListElement:ListElement {
    var id:String
    var name:String
}
