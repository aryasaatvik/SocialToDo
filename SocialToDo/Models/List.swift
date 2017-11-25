//
//  List.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-25.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation

class List<T:Equatable>{
    private var list: [T]
    
    init(){
        //Returns an empty list
        list = [T]()
    }
    
    init(_ listItems:T...){
        list = listItems
    }
    
    init(_ listItems:[T]){
        list = listItems
    }
    
    public func add(item: T){
        self.list.append(item)
    }
    
    public func getElement(similarTo:T) -> T?{
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
    
    public func remove(atIndex:Int){
        list.remove(at:atIndex)
    }
    
    public func remove(element: T) -> Int? {
        for index in 0...list.count {
            if(element == list[index]) {
                list.remove(at: index)
                return index
            }
        }
        return nil
    }
    
    public func getElement(at:Int) -> T{
        return list[at]
    }
    
    // This should always return an array of strings
    public func getElements() -> [T] {
        return list
    }
    
    public func empty(){
        list = []
    }
}
