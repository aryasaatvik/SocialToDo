//
//  ListViewController.swift
//  SocialToDo
//
//  Created by Brannen Hall on 17-11-26.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

//Refactor into multiple protocols

protocol ListViewController: UITableViewDelegate, UITableViewDataSource {
  associatedtype CurrentController: ListController
  //Can we get a UITableViewCell's reuseIdentifier in a static context?
  associatedtype TableViewCell: UITableViewCell
  var reuseIdentifier: String { get }
  var uiTableView: UITableView { get set }
  //Can you get the identifier of a UITableViewCell from a UITableViewCell
  var listController: CurrentController? { get set }
  func changeValues()
  func removeElement()
  func configureCell(_ cell: TableViewCell, element: CurrentController.ControllerList.Item) -> UITableViewCell
}

extension ListViewController {

  func initalization(_ currentTableView: UITableView) {
    uiTableView = currentTableView
    //fbControl = (UIApplication.shared.delegate as! AppDelegate).fbControl!
    //fbControl.delegate = self
    uiTableView.dataSource = self
    uiTableView.delegate = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listController?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.estimatedRowHeight = 75
    tableView.rowHeight = UITableViewAutomaticDimension
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCell
    cell.selectionStyle = .none
    let item = listController!.getElement(at: indexPath.row)
    return configureCell(cell, element: item)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }

}
