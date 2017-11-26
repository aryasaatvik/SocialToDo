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

protocol ListControllerDelegate {
	func reloadTableView()
	func beginUpdates()
	func endUpdates()
	func insertRow(indexPath: IndexPath)
	func deleteRow(indexPath: IndexPath)
}

class ListController<I,T:List<I>>: NSObject, UITableViewDataSource{
	//Represents the list that the controller is managing
	let list: T
	//Represents the directory that the ListController is operating on
	let root:DatabaseReference
	//Represents the users unique facebook provided ID
	let userID: String
	//Represents the ViewController attached to the current instance of the list
	var delegate: ListControllerDelegate?
	
	init(list: T, listID: String, userID: String, root: (String,String) -> DatabaseReference, newListInserted: @escaping (DataSnapshot) -> (), newListRemoved: @escaping (DataSnapshot) -> ()){
		self.list = list
		//Gets the current Facebook User ID
		self.userID = userID
		self.root = root(userID,listID)
		super.init()
		listen(directory: self.root, onInsert: newListInserted, onRemoval: newListRemoved)
	}
	
	func listen(directory:DatabaseReference, onInsert: @escaping (DataSnapshot) -> (), onRemoval: @escaping (DataSnapshot) -> ()){
		directory.observe(.childAdded) { (snapshot) -> Void in
			onInsert(snapshot)
		}
		
		directory.observe(.childRemoved) { (snapshot) -> Void in
			onRemoval(snapshot)
		}
	}
	
	func removeObservers(){
		//Remove listeners when deinitalized
		root.removeAllObservers()
	}
	
	
	func addElement(directory:DatabaseReference, childUpdate: [String:String]){
		directory.childByAutoId().updateChildValues(childUpdate)
	}
	
	func addElement(childUpdate: [String:String]){
		root.childByAutoId().updateChildValues(childUpdate)
	}
	
	func removeElement(directory:DatabaseReference, id:String){
		directory.child("\(id)").removeValue()
	}
	
	func removeElement(id:String){
		root.child("\(id)").removeValue()
	}
	
	@objc func removeElement(trash:Trash){
		removeElement(id: trash.id)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.getElements().count
	}
	
	//Unsure of a default behavior, should be overriden by child classes
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	deinit{
		removeObservers()
	}
}
