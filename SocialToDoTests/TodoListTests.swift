//
//  TodoListTests.swift
//  SocialToDoTests
//
//  Created by Brannen Hall on 17-11-29.
//  Copyright © 2017 Saatvik Arya. All rights reserved.
//

import XCTest
import FirebaseDatabase
import Firebase
@testable import SocialToDo

class TodoListTests: XCTestCase {
  var todoOne: Todo!
  var todoTwo: Todo!
  var todoListOne: TodoList!

  override func setUp() {
    super.setUp()

    FirebaseApp.configure()
    todoOne = Todo(title: "Groceries", identifier: "TL1")
    todoTwo = Todo(title: "Fetch Grocieries 😜", identifier:"TL2")
    todoListOne = TodoList(title: "SampleList", identifier: "TL3", listItems: todoOne, todoTwo)
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    todoOne = nil
    todoTwo = nil
    todoListOne = nil
    super.tearDown()
  }

  func testTodoListJSON() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    var todoOneString: String = String(data: try! JSONEncoder().encode(todoOne), encoding: .utf8)!
    var todoTwoString: String = String(data: try! JSONEncoder().encode(todoTwo), encoding: .utf8)!
    var todoListOneString: String = String(data: try! JSONEncoder().encode(todoListOne), encoding: .utf8)!

    XCTAssert(todoOneString == "{\"title\":\"Groceries\",\"isChecked\":false,\"identifier\":\"TL1\"}")
    XCTAssert(todoTwoString == "{\"title\":\"Fetch Grocieries 😜\",\"isChecked\":false,\"identifier\":\"TL2\"}")
    XCTAssert(todoListOneString == "{\"title\":\"SampleList\",\"todolist\":[{\"title\":\"Groceries\",\"isChecked\":false,\"identifier\":\"TL1\"},{\"title\":\"Fetch Grocieries 😜\",\"isChecked\":false,\"identifier\":\"TL2\"}],\"identifier\":\"TL3\"}")
    let directory = Database.database().reference()

    //directory.child("Raw Data Test").setValue(try? JSONEncoder().encode(todoListOne))
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
