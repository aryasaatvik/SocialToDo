//
//  FriendTodoListViewController.swift
//  
//
//  Created by Saatvik Arya on 11/25/17.
//

import UIKit

class FriendTodoListViewController: UIViewController, UITextFieldDelegate, FBControllerDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var friendTodoControl: FriendTodoListController?
	var fbControl:FBController?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addTodoField: UITextField!
	@IBOutlet weak var todoListTitle: UILabel!
	@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()
		tableView.dataSource = friendTodoControl
		todoListTitle.text = friendTodoControl?.list.title
		addTodoField.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		friendTodoControl?.list.empty()
	}
	
	@objc func keyboardNotification(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
			let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
			let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
			let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
			let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
			if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
				self.keyboardHeightLayoutConstraint?.constant = 0.0
			} else {
				self.keyboardHeightLayoutConstraint?.constant = endFrame!.size.height
			}
			print(keyboardHeightLayoutConstraint.constant)
			UIView.animate(withDuration: duration,
						   delay: TimeInterval(0),
						   options: animationCurve,
						   animations: { self.view.layoutIfNeeded() },
						   completion: nil)
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		addTodoToDelegate()
		return true
	}
	
	func addTodoToDelegate(){
		let todoText = addTodoField.text!
		if (todoText != ""){
			friendTodoControl?.addElement(childUpdate: ["title": todoText, "checked": "false"])
			addTodoField.resignFirstResponder()
			addTodoField.text = nil
		}
	}

	
	@IBAction func handleAddTodoButton(_ sender: Any) {
		addTodoToDelegate()
	}
	
	@IBAction func handleBackButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func promptFacebookLogin() {
		let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
		present(facebookLoginViewController!, animated: true, completion: nil)
	}
	
}
extension FriendTodoListViewController: FriendTodoListDelegate {
	func reloadTableView() {
		self.tableView.reloadData()
	}
	func beginUpdates() {
		self.tableView.beginUpdates()
	}
	func endUpdates() {
		self.tableView.endUpdates()
	}
	func insertRow(indexPath: IndexPath) {
		self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	}
	func deleteRow(indexPath: IndexPath) {
		self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	}
}


