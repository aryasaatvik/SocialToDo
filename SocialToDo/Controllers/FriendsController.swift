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
	var friendsList: FriendsList = FriendsList()
	
	override init() {
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
			var parameters: [String : Any]? = ["fields": "first_name, last_name, email"]
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
					let firstName = friend["first_name"]!
					let lastName = friend["last_name"]!
					let name = "\(firstName) \(lastName)"
					self.friendsList.add(friends: [Friend(name)])
					
				}
			case .failed(let error):
				print("User Info Graph Request Failed: \(error)")
			}
		}
		connection.start()
		
		
		self.delegate?.reloadTableView()
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return friendsList.getElements().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.rowHeight = 75
		let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
		cell.selectionStyle = .none
		let friend = friendsList.getElementAt(atIndex: indexPath.row)
		cell.name.text = friend.name
		return cell
	}
	
	
	
	
}



