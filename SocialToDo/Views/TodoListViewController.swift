//
//  MyListsViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/9/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoListViewController: UIViewController, UITextFieldDelegate {
  /*//typealias ListController = TodoListController
  typealias TableViewCell = TodoCell
  var reuseIdentifier = "todo"
  ///TODO: TTListViewController will set the appropriate listController on it's prepare (for segue:, sender:) method
  //var listController: TodoListController?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addTodoField: UITextField!
  @IBOutlet weak var addTodoButton: UIButton!
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var todoListTitle: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    initalization(tableView)
    tableView.delegate = self
    todoListTitle.text = listController!.list.title
    addTodoField.delegate = self
    todoListTitle.adjustsFontSizeToFitWidth = true

    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    /*Database.database().reference().removeObserver(withHandle: (todoControl?.taskAddedObserver)!)
     Database.database().reference().removeObserver(withHandle: (todoControl?.taskRemovedObserver)!)*/
    //todoControl?.list.empty()

  }

  @objc func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
      let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
      if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
        self.keyboardHeightLayoutConstraint?.constant = 0.0
      } else {
        self.keyboardHeightLayoutConstraint?.constant = -endFrame!.size.height
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
    addTodo()
    return true
  }

  @IBAction func handleAddTodoButton(_ sender: Any) {
    addTodo()
  }

  func addTodo() {
    let todoText = addTodoField.text!
    if todoText != "" {
      listController?.addElement(childUpdate: ["title": todoText, "checked": "false"])
      addTodoField.resignFirstResponder()
      addTodoField.text = nil
    }
  }

  @IBAction func handleBackButton(_ sender: Any) {
    listController!.removeObservers()
    dismiss(animated: true, completion: nil)
  }

  func configureCell(_ cell: TodoCell, element: Todo) -> UITableViewCell {
    var cell = cell
    cell.label!.text = element.title
    // initialize checkbox
    cell.checkbox.isSelected = element.isChecked
    cell.checkbox.id = element.id
    cell.checkbox.addTarget(self, action: #selector(changeValues(checkbox:)), for: .touchUpInside)
    cell.trash.id = element.id
    cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
    return cell
  }

  @objc func changeValues(checkbox: Checkbox) {
    var todo = list.getElement(id: checkbox.id)!
    let todoRef = root.child("/\(todo.id)/")

    /*if(checkbox.isSelected) {
      checkbox.isSelected = false
      let childUpdate = ["checked": "false"]
      todoRef.updateChildValues(childUpdate)
      todo.isChecked = false

    } else {
      checkbox.isSelected = true
      let childUpdate = ["checked": "true"]
      todoRef.updateChildValues(childUpdate)
      todo.isChecked = true
    }*/
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
   }*/*/

}
