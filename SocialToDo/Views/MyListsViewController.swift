//
//  MyListsViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit

class MyListsViewController: UIViewController, UITextFieldDelegate, FBControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var todoControl:TodoController?
    var fbControl:FBController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoField: UITextField!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoControl = appDelegate.todoControl
		todoControl?.delegate = self
        fbControl = appDelegate.fbControl
        fbControl?.delegate = self
        fbControl?.checkLogin()
		
        tableView.dataSource = todoControl
		addTodoField.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                self.keyboardHeightLayoutConstraint?.constant = -50.0 + (endFrame?.size.height)! 
            }
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
        handleAddTodoButton(textField)
        return true
    }
        
    @IBAction func handleAddTodoButton(_ sender: Any) {
        let todoText = addTodoField.text!
        todoControl?.addElement(item: TodoListItem(todoText))
        addTodoField.resignFirstResponder()
        addTodoField.text = nil
        tableView.reloadData()
    }
    
	@IBAction func handleLogoutButton(_ sender: Any) {
		fbControl?.logout(vc: self)
	}
	
	func promptFacebookLogin() {
        let facebookLoginViewController = storyboard?.instantiateViewController(withIdentifier: "FacebookLogin")
        present(facebookLoginViewController!, animated: true, completion: nil)
    }}

extension MyListsViewController: TodoControllerDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

