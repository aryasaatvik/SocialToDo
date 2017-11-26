//
//  AddFriend.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/21/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class AddFriend: UIButton {
	
	var index: Int = 0
	// MARK: Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupAddFriend()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupAddFriend()
	}
	
	// MARK: Private Methods
	
	private func setupAddFriend() {
		setImage(UIImage(named: "addFriend"), for: .normal)
	}
	
	// MARK: Button Action
	
	
	
}

