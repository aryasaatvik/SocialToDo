//
//  TLListController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol TLListControllerDelegate:ListControllerDelegate {
    func segue(_ todoList:TodoList)
}

class TLListController: ListController<TLList> {
	let vc: String
	init(path: String, userID: String, vc: String) {
		self.vc = vc
		super.init(list:TLList(), path: path, userID: userID, listID: "", root: getDatabase,newListInserted: newListInserted, newListRemoved: newListRemoved)
	}
    
	func getDatabase(_ path:String, _ userID: String, _ listID: String) -> DatabaseReference{
        return Database.database().reference().child("\(path)/\(userID)")
	}
    
    func newListInserted(snapshot:DataSnapshot){
        print("SNAPSHOT: \(snapshot)")
        if let todoList = snapshot.value as? NSDictionary {
            let listID = snapshot.key
            let title = "\(todoList["name"]!)"
            let newList = TodoList(title, id: listID)
            self.delegate?.beginUpdates()
            self.list.add(item: newList)
            self.delegate?.insertRow(indexPath: IndexPath(row: self.list.getElements().count - 1, section: 0))
            self.delegate?.endUpdates()
            
        }
    }
    
    func newListRemoved(snapshot:DataSnapshot){
        print("SNAPSHOT: \(snapshot)")
        let listID = snapshot.key
        self.delegate?.beginUpdates()
        let index = self.list.remove(id: listID)!
        self.delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0))
        self.delegate?.endUpdates()
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(vc == "TLList") {
			tableView.estimatedRowHeight = 80
			tableView.rowHeight = UITableViewAutomaticDimension
			let cell = tableView.dequeueReusableCell(withIdentifier: "list") as! ListCell
			let todoList = list.getElement(at: indexPath.row)
//			cell.background.image = UIImage(named: "TLList-Cell")
			cell.title.text = todoList.title
			cell.trash.id = todoList.id
			cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
			return cell
		}
		else if(vc == "FriendTodoLists") {
			tableView.rowHeight = 75
			let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTodoListsCell") as! FriendTodoListsCell
			let todoList = list.getElement(at: indexPath.row)
			cell.name.text = todoList.title
			return cell
		}
		else if(vc == "SharedTLList") {
			tableView.rowHeight = 75
			let cell = tableView.dequeueReusableCell(withIdentifier: "SharedListCell") as! SharedListCell
			let todoList = list.getElement(at: indexPath.row)
			cell.title.text = todoList.title
			cell.trash.id = todoList.id
			cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
			return cell
		}
		return UITableViewCell()
	}
	
}
