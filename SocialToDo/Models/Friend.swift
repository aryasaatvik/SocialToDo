//
//  Friend.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

enum FriendRequestState {
    case notFriends
    
    case requestSent
    
    case requestRecieved
    
    case friends
}

class Friend:ListElement {
    var name: String
    var id: String
//	var email: String
    //TODO: Have the code use enums instead of passing around string literals
    var _isFriended: FriendRequestState
    var isFriended: String {
        get {
            return serializeState()
        } set(value) {
            _isFriended = Friend.deserializeState(isFriended: value)
        }
    }

	
	init(_ name: String, _ id: String) {
		self.name = name
		self.id = id
		_isFriended = FriendRequestState.notFriends
	}
	
	init(_ name: String, _ id: String, _ isFriended: FriendRequestState) {
		self.name = name
		self.id = id
		self._isFriended = isFriended
	}
	
	init(name: String, id: String, isFriended: FriendRequestState) {
		self.name = name
		self.id = id
		self._isFriended = isFriended
	}
    
    init(_ name:String, _ id:String, _ isFriended:String){
        self.name = name
        self.id = id
        self._isFriended = Friend.deserializeState(isFriended: isFriended)
    }
    
    func serializeState() -> String{
        switch _isFriended {
        case .notFriends:
            return "false"
        case .requestSent:
            return "requestSent"
        case .friends:
            return "true"
        case .requestRecieved:
            return "requestRecieved"
        }
    }
    
    static func deserializeState(isFriended:String) -> FriendRequestState {
        switch isFriended {
        case "true":
            return .friends
        case "requestSent":
            return .requestSent
        case "false":
            return .notFriends
        case "requestRecived":
            return .requestRecieved
        default:
            return .notFriends
        }
    }
	
}
