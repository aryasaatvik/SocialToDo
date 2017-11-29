//
//  ListController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-24.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol ListController {
    associatedtype ControllerList: List
	//Represents the list that the controller is managing
    var list: ControllerList { get set }
	//Represents the directory that the ListController is operating on
    var root: DatabaseReference { get }
	//Represents the users unique facebook provided ID
    var userID: String { get }
	//Represents the ViewController attached to the current instance of the list
    //var delegate: ListControllerDelegate? { get set }
    //Function that is called when a new item is inserted
    //var newListInserted: (DataSnapshot, ControllerList, ListControllerDelegate) -> Void { get }
    //Funciton that is called when a new item is removed
    //var newListRemvoed: (DataSnapshot, ControllerList, ListControllerDelegate) -> Void { get }

    /*init(list: , path: String, userID: String, listID: String, root: (String, String, String) -> DatabaseReference, newListInserted: @escaping (DataSnapshot) -> (), newListRemoved: @escaping (DataSnapshot) -> ()){
		self.list = list
		//Gets the current Facebook User ID
		self.userID = userID
		self.root = root(path, userID, listID)
		super.init()
		listen(directory: self.root, onInsert: newListInserted, onRemoval: newListRemoved)
	}*/
}

extension ListController {

    var count: Int {
        get {
            return list.count
        }
    }

	func listen() {
		root.observe(.childAdded) { (snapshot) -> Void in
			//self.newListInserted(snapshot, self)
		}

		root.observe(.childRemoved) { (snapshot) -> Void in
			//self.newListRemvoed(snapshot, self)
		}
	}

	func removeObservers() {
		//Remove listeners when deinitalized
		root.removeAllObservers()
	}

	func addElement(childUpdate: [String: String]) {
		root.childByAutoId().updateChildValues(childUpdate)
	}

    //TODO: Have this use ListElement types
	func removeElement(id: String) {
		root.child("\(id)").removeValue()
	}

    func getElement(at: Int) -> ControllerList.Item {
        return list.getElement(at:at)
    }
    /*
    I am under the belief that all list controlers operate under one directory. If not, reenable this code.
     
    func addElement(directory:DatabaseReference, childUpdate: [String:String]){
        directory.childByAutoId().updateChildValues(childUpdate)
    }
    
    func removeElement(directory:DatabaseReference, id:String){
        directory.child("\(id)").removeValue()
    }
    */
}
/*
 Add this as an extension to all classes that implement this protocol
 TODO:See if logic can be implemented in ViewController
@objc extension ListController {
    @objc func removeElement(trash:Trash){
        removeElement(id: trash.id)
    }
}
 */
