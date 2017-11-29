//
//  Trash.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/19/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class Trash: UIButton {

	var id: String = ""
	// MARK: Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupTrash()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupTrash()
	}

	// MARK: Private Methods

	private func setupTrash() {
		setImage(UIImage(named: "trash"), for: .normal)
		setImage(UIImage(named: "trash"), for: .selected)
	}

	// MARK: Button Action

}
