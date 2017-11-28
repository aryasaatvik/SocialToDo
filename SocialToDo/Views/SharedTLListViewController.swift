//
//  SharedTLListViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/25/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseAuth

class SharedTLListViewController: UIViewController, UITextFieldDelegate, FBControllerDelegate, UITableViewDelegate {

	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var sharedListControl: TLListController?
	var fbControl:FBController?
	var todoControl: TodoListController?
	var todoList: TodoList?

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addTodoListField: UITextField!
	@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
		sharedListControl = appDelegate.sharedListControl
		sharedListControl?.delegate = self
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()

		tableView.dataSource = sharedListControl
		tableView.delegate = self

		addTodoListField.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
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
				self.keyboardHeightLayoutConstraint?.constant =  -endFrame!.size.height + 50
			}
			UIView.animate(withDuration: duration,
						   delay: TimeInterval(0),
						   options: animationCurve,
						   animations: { self.view.layoutIfNeeded() },
						   completion: nil)
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		handleAddTodoList(textField)
		return true
	}
	
	@IBAction func handleAddTodoList(_ sender: Any) {
		let todoTitle = addTodoListField.text!
		sharedListControl?.addElement(childUpdate: ["name": todoTitle])
		addTodoListField.resignFirstResponder()
		addTodoListField.text = nil
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoList = sharedListControl!.list.getElement(at: indexPath.row)
		let title = todoList!.title
		let id = todoList!.id
		print("TABLE VIEW ROW SELECTED")
		print("TODOLIST REQUESTED: \(title), \(id)")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "sharedTodoListVC") as? SharedTodoListViewController {
			destinationVC.sharedTodoControl = TodoListController(todoList!, path: "sharedLists", userID: Auth.auth().currentUser!.uid, vc: "SharedTodoList")
			destinationVC.sharedTodoControl?.delegate = destinationVC
			destinationVC.navigationItem.title = destinationVC.sharedTodoControl?.list.title
			self.navigationController?.pushViewController(destinationVC, animated: true)
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 75
	}

}
extension SharedTLListViewController: TLListControllerDelegate {
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
	
	func segue(_ todoList:TodoList){
		print("Does this get called?")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "sharedTodoListVC") as? TodoListViewController {
			destinationVC.todoControl = TodoListController(todoList, path: "sharedLists", userID: Auth.auth().currentUser!.uid, vc: "SharedTodoList")
			destinationVC.todoControl?.delegate = destinationVC
			self.present(destinationVC, animated: true, completion: nil)
		}
	}
}

