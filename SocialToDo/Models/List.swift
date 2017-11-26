//
//  List.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-25.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

protocol List {
    associatedtype Item:ListElement
    var list:[Item] { get set }
}

extension List {
    mutating public func add(item: Item){
        self.list.append(item)
    }
    
    mutating public func add(items: [Item]){
        for item in items {
            list.append(item)
        }
    }
    
    public func getElement(id:String) -> Item? {
        for item in list {
            if(id == item.id) {
                return item
            }
        }
        return nil
    }
    
    public func getElement(similarTo:Item) -> Item?{
        for item in list {
            if(item == similarTo) {
                return similarTo
            }
        }
        return nil
    }

    /*Warning and TODO: If one element is removed, Swift will automatically
     reindex the others, so further removes should not be permitted
     until tableView recieves new, properly indexed elements*/
    
    mutating public func remove(at:Int){
        list.remove(at:at)
    }
    
    mutating public func remove(id:String) -> Int? {
        for index in 0...list.count {
            if(id == list[index].id) {
                list.remove(at: index)
                return index
            }
        }
        return nil
    }
    
    mutating public func remove(element: Item) -> Int? {
        for index in 0...list.count {
            if(element == list[index]) {
                list.remove(at: index)
                return index
            }
        }
        return nil
    }
    
    public func getElement(at:Int) -> Item{
        return list[at]
    }
    
    // This should always return an array of strings
    public func getElements() -> [Item] {
        return list
    }
    
    mutating public func empty(){
        list = []
    }
}


