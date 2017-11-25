//
//  FriendsListController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/25/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

protocol FriendsListControllerDelegate {
	func reloadTableView()
}

class FriendsListController: NSObject, UITableViewDataSource {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var delegate: FriendsListControllerDelegate?
	var friendList = FriendList()
	var ref: DatabaseReference!
	var friendsRef: DatabaseReference!
	var userID: String

	
	override init() {
		userID = (Auth.auth().currentUser?.uid)!
		ref = Database.database().reference()
		friendsRef = ref.child("users/\(userID)/friends")
		super.init()
		fetchFriends()
	}
	
	func fetchFriends() {
		friendsRef.observe(.childAdded) { (snapshot) in
			let friendID = snapshot.key
			if let isFriended = snapshot.value as? String {
				let friendRef = self.ref.child("users/\(friendID)")
				friendRef.observeSingleEvent(of: .value, with: { (snapshot) in
					if let friendInfo = snapshot.value as? NSDictionary {
						if let friendName = friendInfo["name"] {
							if ("\((isFriended))" == "true") {
								let friend = Friend("\(friendName)", "\(friendID)", "\(isFriended)")
								self.friendList.add(friends: [friend])
								self.delegate?.reloadTableView()
							}
						}
					}
				})
			}
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friendList.getElements().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "friend") as! FriendListCell
		let friend = friendList.getElementAt(atIndex: indexPath.row)
		cell.name.text = friend.name
		return cell
	}
	

}
