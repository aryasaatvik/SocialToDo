//
//  FriendsController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

protocol FriendsControllerDelegate {
	func reloadTableView()
}

class FriendsController: NSObject, UITableViewDataSource {
	var delegate: FriendsControllerDelegate?
	var friendList: FriendList = FriendList()
	var ref: DatabaseReference!
	var friendsRef: DatabaseReference!
	var userID: String
	
	override init() {
		ref = Database.database().reference()
		userID = (Auth.auth().currentUser?.uid)!
		friendsRef = ref.child("users/\(userID)/friends/")
		super.init()
		fetchFriends()
	}
	
	func fetchFriends() {
		// create facebook graph request
		struct UserFriendsRequest: GraphRequestProtocol {
			struct Response: GraphResponseProtocol {
				
				var friends: [NSDictionary]?
				
				init(rawResponse: Any?) {
					// Decode JSON from rawResponse into other properties here.
					
					guard let response = rawResponse as? Dictionary<String, Any> else {
						print("Error Fetching Friends")
						return
					}
					
					if let friends = response["data"] as? [NSDictionary]{
						self.friends = friends
					}
				}
			}
			
			var graphPath = "/me/friends"
			var parameters: [String : Any]? = ["fields": "first_name, last_name, id"]
			var accessToken = AccessToken.current
			var httpMethod: GraphRequestHTTPMethod = .GET
			var apiVersion: GraphAPIVersion = .defaultVersion
		}
		
		// initiate facebook graph request
		let connection = GraphRequestConnection()
		connection.add(UserFriendsRequest()) { response, result in
			switch result {
			case .success(let response):
				let friends = response.friends!
				for friend in friends {
					let fbid = "\(friend["id"]!)"
					let name = "\(friend["first_name"]!) \(friend["last_name"]!)"
					let fbIDRef = self.ref.child("fbID")
					fbIDRef.observeSingleEvent(of: .value, with: { (snapshot) in
						let value = snapshot.value as? NSDictionary
						let friendID = "\((value?[fbid])!)"
						self.friendsRef.observeSingleEvent(of: .value, with: { (snapshot) in
							let value = snapshot.value as? NSDictionary
							let isFriended = "\(value?["isFriended"] ?? "false")" == "true"
							self.friendList.add(friends: [Friend(name, friendID, isFriended)])
						}) { (error) in
							print(error.localizedDescription)
						}
					}) { (error) in
						print(error.localizedDescription)
					}
				}
			case .failed(let error):
				print("User Info Graph Request Failed: \(error)")
			}
		}
		connection.start()
		
		
		self.delegate?.reloadTableView()
		
	}
	
	@objc func addFriend(addFriend: AddFriend) {
		if(!addFriend.isSelected){
			addFriend.isSelected = true
			let friend = friendList.getElementAt(atIndex: addFriend.index)
			let childUpdate = [friend.id: "true"]
			self.friendsRef.updateChildValues(childUpdate)
			let friendRef = ref.child("users/\(friend.id)/friends")
			let friendUpdate = [userID: "true"]
			friendRef.updateChildValues(friendUpdate)
			friend.isFriended = true
			
		}
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friendList.getElements().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
		cell.selectionStyle = .none
		let friend = friendList.getElementAt(atIndex: indexPath.row)
		cell.name.text = friend.name
		cell.addFriend.isSelected = friend.isFriended
		cell.addFriend.index = indexPath.row
		cell.addFriend.addTarget(self, action: #selector(addFriend(addFriend:)), for: .touchUpInside)
		return cell
	}
	
	
	
	
}



