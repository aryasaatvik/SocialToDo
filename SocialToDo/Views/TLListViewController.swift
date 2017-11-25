//
//  TLListViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit


class TLListViewController: UIViewController, UITextFieldDelegate, FBControllerDelegate, UITableViewDelegate {
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var listControl:TLListController?
	var fbControl:FBController?
	var todoControl: TodoListController?
	var todoList: TodoList?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addTodoListField: UITextField!
	@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		listControl = appDelegate.listControl
		listControl?.delegate = self
		fbControl = appDelegate.fbControl
		fbControl?.delegate = self
		fbControl?.checkLogin()
		
		tableView.dataSource = listControl
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
				self.keyboardHeightLayoutConstraint?.constant = -50.0 + endFrame!.size.height
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
		listControl?.addTodoList(title: todoTitle)
		addTodoListField.resignFirstResponder()
		addTodoListField.text = nil
	}
	
	func promptFacebookLogin() {
		let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
		present(facebookLoginViewController!, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		todoList = listControl!.list.getElementAt(atIndex: indexPath.row)
		let title = todoList!.title
		let id = todoList!.id
		print("TABLE VIEW ROW SELECTED")
		print("TODOLIST REQUESTED: \(title), \(id)")
		if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "todoListVC") as? TodoListViewController {
			destinationVC.todoControl = TodoListController(todoList!)
			destinationVC.todoControl?.delegate = destinationVC
			self.present(destinationVC, animated: true, completion: nil)
		}
	}
	
	@IBAction func handleLogoutButton(_ sender: Any) {
		fbControl?.logout(vc: self)
	}
	
}


extension TLListViewController: TLListControllerDelegate {
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
