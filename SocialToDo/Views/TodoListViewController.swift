//
//  MyListsViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoListViewController: UIViewController, UITextFieldDelegate, FBControllerDelegate, UITableViewDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var todoControl:TodoListController?
    var fbControl:FBController?
    var timeEdit: IndexPath?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoField: UITextField!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        fbControl = appDelegate.fbControl
        fbControl?.delegate = self
        fbControl?.checkLogin()
		tableView.dataSource = todoControl
        tableView.delegate = self
		addTodoField.delegate = self

		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		/*Database.database().reference().removeObserver(withHandle: (todoControl?.taskAddedObserver)!)
		Database.database().reference().removeObserver(withHandle: (todoControl?.taskRemovedObserver)!)*/
		todoControl?.list.empty()
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
                self.keyboardHeightLayoutConstraint?.constant = -endFrame!.size.height + 50
            }
			print(keyboardHeightLayoutConstraint.constant)
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
	

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTodoToDelegate()
        return true
    }
        
    @IBAction func handleAddTodoButton(_ sender: Any) {
        addTodoToDelegate()
    }
    
    func addTodoToDelegate(){
        let todoText = addTodoField.text!
        if (todoText != ""){
            todoControl?.addElement(childUpdate: ["title": todoText, "checked": "false"])
            addTodoField.resignFirstResponder()
            addTodoField.text = nil
        }
    }

	func promptFacebookLogin() {
        let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
        present(facebookLoginViewController!, animated: true, completion: nil)
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timeEdit = indexPath
        let todoCell = (tableView.cellForRow(at: indexPath) as! TodoCell)
        todoCell.datePicker.isEnabled = true
        todoCell.datePicker.isHidden = false
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        timeEdit = nil
        let todoCell = (tableView.cellForRow(at: indexPath) as! TodoCell)
        todoCell.datePicker.isEnabled = false
        todoCell.datePicker.isHidden = true
        self.tableView.reloadData()
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (timeEdit != nil && indexPath == timeEdit){
            return 140
        }
        return 60
    }
}

extension TodoListViewController: TodoListControllerDelegate {
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

