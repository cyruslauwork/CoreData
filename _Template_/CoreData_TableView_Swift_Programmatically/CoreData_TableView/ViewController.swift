//
//  ViewController.swift
//  CoreData_TableView
//
//  Created by Cyrus on 8/6/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let memberTableView = UITableView() // 1.2 TableView: The UITableView
    
    // 2.1 CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Declare a Core Data constant
    var memberList: [Member] = [] // Declare an array to record database query results, then use this array as data of UITableView
    // 2.1 end
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1.3 TableView: Apply to view
        view.addSubview(self.memberTableView)
        self.memberTableView.backgroundColor = UIColor.systemOrange
        self.memberTableView.translatesAutoresizingMaskIntoConstraints = false
        self.memberTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        self.memberTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        self.memberTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        self.memberTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        addBtn.tintColor = UIColor.white
        let testBtn = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(testBtnTapped))
        testBtn.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [addBtn, testBtn]
        // 1.3 end
        
        // 2.2 CoreData
        // Assign TableView's delegate and dataSource to Self(ViewController)
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        // 2.2 end
    }
    
    
    
    // 1.4 TableView: Button function settings
    @objc func addBtnTapped() {
        // 2.4 CoreData: Add an action to the add button
        self.showAlert(type:"新增", alertTitle: "新增人員資料", actionHandler: { (textFields: [UITextField]?) in // "actionHandler" doesn't take effect until the entire function completes
            DispatchQueue.main.async {
                self.insertObject(department: String(textFields?[0].text ?? ""),
                                  id: Int(textFields?[1].text ?? "") ?? 0,
                                  name: String(textFields?[2].text ?? "")
                )
            }
        })
        // 2.4 end
    }
    @objc func testBtnTapped() {
    }
    // 1.4 end
    
    // 2.5 CoreData: Insert, showAlert(), Query, Update, Delete
    // Insert
    func insertObject(department: String, id: Int, name: String) {
        let member = NSEntityDescription.insertNewObject(forEntityName: "Member", into: self.context) as! Member
        member.id = Int32(id)
        member.name = name
        member.department = department
        do {
            try self.context.save()
        } catch {
            fatalError("\(error)")
        }
        // After adding, query the database data and display the database data on the TableView
        self.memberList = self.selectObject()
        DispatchQueue.main.async {
            self.memberTableView.reloadData()
        }
    }
    
    // Implement an Alert to allow user to enter new or edit data
    func showAlert(type: String, alertTitle: String, actionHandler: ((_ textFields: [UITextField]?) -> Void)? = nil) { // Set a temporary value "nil" for the last parameter
        // Define alert
        let alert = UIAlertController.init(
           title:          alertTitle,
           message:        "",
           preferredStyle: .alert
        )
        // Adding three new input boxes to allow users to input department, serial number and name respectively
        for index in 0...2 {
           alert.addTextField { (textField:UITextField) in
               if index == 0 {
                   textField.placeholder = type + "部門"
               } else if index == 1 {
                   textField.placeholder = type + "編號"
               } else if index == 2 {
                   textField.placeholder = type + "姓名"
               }
           }
        }
        // Add action to alert
        alert.addAction(UIAlertAction.init(title: "確定", style: .default, handler: { (action:UIAlertAction) in
           DispatchQueue.main.async {
               actionHandler?(alert.textFields) // Return the last parameter of showAlert(), finally passed to where showAlert() is invoked through "-> Void"
           }
        }))
        // Add action to alert
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { _ in
           DispatchQueue.main.async {

           }
        }
        alert.addAction(cancelAction)
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // Query
    func selectObject() -> Array<Member> {
        var array:[Member] = []
        let request = NSFetchRequest<Member>(entityName: "Member")
        do {
            let results = try self.context.fetch(request)
            for result in results {
                array.append(result)
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return array
    }
    
    // Update
    func updateObject(indexPath: IndexPath) {
        self.showAlert(type: "修改", alertTitle: "修改人員資料") { (textFields: [UITextField]?) in
            // After updating the query results, call context.save() to save
            let request = NSFetchRequest<Member>(entityName: "Member")
            do {
                let results = try self.context.fetch(request)
                for item in results {
                    if item.id == self.memberList[indexPath.row].id &&
                        item.name == self.memberList[indexPath.row].name &&
                        item.department == self.memberList[indexPath.row].department { // If it matches any items in this Core Data entity
                        
                        item.department = textFields?[0].text
                        item.id = Int32(Int(textFields?[1].text ?? "") ?? 0)
                        item.name = textFields?[2].text
                    }
                }
                try self.context.save()
            }catch{
                fatalError("Failed to fetch data: \(error)")
            }
            // After adding, query the database data and display the database data on the TableView
            self.memberList = self.selectObject()
            DispatchQueue.main.async {
                self.memberTableView.reloadData()
            }
        }
    }
    
    // Delete
    func deleteObject(indexPath: IndexPath) {
        // After the query results are deleted, call context.save() to save
        let request = NSFetchRequest<Member>(entityName: "Member")
        do {
            let results = try self.context.fetch(request)
            for item in results {
                if item.id == self.memberList[indexPath.row].id &&
                    item.name == self.memberList[indexPath.row].name &&
                    item.department == self.memberList[indexPath.row].department { // If it matches any items in this Core Data entity
                    context.delete(item)
                }
            }
            try self.context.save()
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        // Define alert
        let alert = UIAlertController.init(
            title:          "已刪除",
            message:        "",
            preferredStyle: .alert
        )
        // Add action to alert
        let okAction = UIAlertAction.init(title: "OK", style: .default)
        alert.addAction(okAction)
        // Show alert
        self.present(alert, animated: true, completion: {
            // After adding, query the database data and display the database data on the TableView
            self.memberList = self.selectObject()
            DispatchQueue.main.async {
                self.memberTableView.reloadData()
            }
        })
    }
    // 2.5 end
}



// 2.3 CoreData
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // "numberOfRowsInSection"
        // Core Data data length
        return self.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // It will return "UITableViewCell"
        // Display Core Data data
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "編號：" + String(self.memberList[indexPath.row].id) +
                                " , 部門：" + String(self.memberList[indexPath.row].department ?? "") +
                                " , 姓名：" + String(self.memberList[indexPath.row].name ?? "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // "didSelectRowAt"
        // Let the user choose to delete or edit the data by clicking on a cell
        let alert = UIAlertController.init(
            title:          "更新或刪除一筆資料",
            message:        "",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction.init(title: "更新", style: .default) { _ in
            DispatchQueue.main.async {
                self.updateObject(indexPath: indexPath)
            }
        }
        let cancelAction = UIAlertAction.init(title: "刪除", style: .default) { _ in
            DispatchQueue.main.async {
                self.deleteObject(indexPath: indexPath)
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
// 2.3 end
