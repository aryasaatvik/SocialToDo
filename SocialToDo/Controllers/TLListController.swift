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

typealias TLListControllerDelegate = ListControllerDelegate

class TLListController: ListController<TodoList,TLList> {
	init() {
        super.init(list:TLList(),listID:"",root: getDatabase,newListInserted: newListInserted, newListRemoved: newListRemoved)
	}
    
    func getDatabase(_ userID:String, _ id:String) -> DatabaseReference{
        return Database.database().reference().child("privateLists/\(userID)/")
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
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "list") as! ListCell
		let todoList = list.getElement(at: indexPath.row)
		cell.title.text = todoList.title
		cell.trash.id = todoList.id
		cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
		return cell
	}
	
}
