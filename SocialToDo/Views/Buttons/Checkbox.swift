//
//  Checkbox.swift
//  Checkbox
//
//  Created by Saatvik Arya on 11/11/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class Checkbox: UIButton {

	var id: String = ""
	// MARK: Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCheckbox()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupCheckbox()
	}

	// MARK: Private Methods

	private func setupCheckbox() {
		setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
		setImage(UIImage(named: "checkbox-checked"), for: .selected)
	}

	// MARK: Button Action

}
