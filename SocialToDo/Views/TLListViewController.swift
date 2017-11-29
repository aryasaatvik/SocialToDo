//
//  TLListViewController.swift
//  SocialToDo
//
//  Created by Saatvik Arya on 11/22/17.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//
import UIKit
import FirebaseAuth

class TLListViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var currentTableView: UITableView!
  @IBOutlet weak var addTodoListField: UITextField!
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    var uiTableView: UITableView = currentTableView
    //initalization(uiTableView)

    addTodoListField.delegate = self
    NotificationCenter
      .default
      .addObserver(self,
                   selector: #selector(self.keyboardNotification(notification:)),
                   name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
      let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
      let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
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
    //listController?.addElement(childUpdate: ["name": todoTitle])
    addTodoListField.resignFirstResponder()
    addTodoListField.text = nil
  }

  /*func configureCell(_ cell: ListCell, element: TodoList) -> UITableViewCell {
    cell.title.text = element.title
    cell.trash.id = element.identifier
    cell.trash.addTarget(self, action: #selector(removeElement(trash:)), for: .touchUpInside)
    return cell
  }*/

  /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //let todoList: TodoList = listController!.getElement(at: indexPath.row)
    let title = todoList.title
    let id = todoList.identifier
    print("TABLE VIEW ROW SELECTED")
    print("TODOLIST REQUESTED: \(title), \(id)")
    if let destinationVC = storyboard?
      .instantiateViewController(withIdentifier: "todoListVC")
      as? TodoListViewController {
        destinationVC.listController = TodoListController(todoList)
        destinationVC.listController?.delegate = destinationVC
        self.present(destinationVC, animated: true, completion: nil)
    }
  }*/

  @IBAction func handleLogoutButton(_ sender: Any) {
    //fbControl.logout(vc: self)
  }

  /*@objc func removeElement(trash:Trash){
    removeElement(id: trash.id)
  }*/
}
