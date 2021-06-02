//
//  DailyPlanListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

enum TodoViewType: Int {
    case TODO_ACTIVE = 0
    case TODO_COMPLETED = 1
    case TODO_ALL = 2
}

class DailyPlanListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dailyPlanTableView: UITableView!
    
    var editTodoRec: DailyPlanRecItem!
    var dailyTodoRecCount: Int!
    var todoStr: String!
    
    @IBOutlet weak var todoBtn: RoundButton!
    @IBOutlet weak var completedBtn: RoundButton!
    @IBOutlet weak var allBtn: RoundButton!
    
    var dailyTodoAllItemArray = [DailyPlanRecItem]()
    var dailyPlanItemArray = [DailyPlanRecItem]()
    var todoView: TodoViewType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView = .TODO_ACTIVE
        loadDailyPlanRecords()
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadDailyPlanRecords()
        DispatchQueue.main.async {
            self.dailyPlanTableView.reloadData() }
    }
    
    @IBAction func todoAction(_ sender: UIButton) {
        todoView = .TODO_ACTIVE
        todoBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        completedBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadDailyPlanRecords()
        DispatchQueue.main.async {
            self.dailyPlanTableView.reloadData() }
    }
    
    @IBAction func completedAction(_ sender: UIButton) {
        todoView = .TODO_COMPLETED
        todoBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        allBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadDailyPlanRecords()
        DispatchQueue.main.async {
            self.dailyPlanTableView.reloadData() }
    }
    
    @IBAction func allAction(_ sender: UIButton) {
        todoView = .TODO_ALL
        todoBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        loadDailyPlanRecords()
        DispatchQueue.main.async {
            self.dailyPlanTableView.reloadData() }
    }
    
    func setupTableView() {
        dailyPlanTableView.allowsSelection = true
        dailyPlanTableView.allowsSelectionDuringEditing = true
        
        dailyPlanTableView.delegate = self
        dailyPlanTableView.dataSource = self
        
        // Set automatic dimensions for row height
        dailyPlanTableView.rowHeight = UITableView.automaticDimension
        dailyPlanTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.dailyPlanTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        dailyPlanTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addTodoDialog(msg: "")
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        /*let buttonPostion = sender.convert(sender.bounds.origin, to: dailyPlanTableView)
        
        if let indexPath = dailyPlanTableView.indexPathForRow(at: buttonPostion) {
            let updtTodoRec = getRecord(actionForRowAt: indexPath)!
            saveContext()
        } */
        saveContext()
    }

    func addTodoDialog(msg: String) {
        var recExists = false
        let alert = UIAlertController(title: "Daily Todo", message: nil, preferredStyle: .alert)
        if msg == "" {
            alert.addTextField { (textField) in
                textField.placeholder = "Default placeholder text"
            }
        } else {
            alert.addTextField { (textField) in
                textField.text = msg
                recExists = true
            }
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            self.todoStr = userText
            if recExists {
                self.updateRecord()
            } else {
                self.createRecord()
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadDailyPlanRecords() {
        dailyTodoAllItemArray.removeAll()
        dailyPlanItemArray.removeAll()
        let request: NSFetchRequest<DailyPlanRecItem> = DailyPlanRecItem.fetchRequest()
        do {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                dailyTodoAllItemArray = try context.fetch(request)
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                dailyTodoAllItemArray = try context.fetch(request)
            }
            
            for (_, element) in dailyTodoAllItemArray.enumerated() {
                if todoView == TodoViewType.TODO_ALL {
                    dailyPlanItemArray.append(element)
                }
                else if todoView == TodoViewType.TODO_ACTIVE {
                    if element.completed == false {
                        dailyPlanItemArray.append(element)
                    }
                } else {
                    if element.completed {
                        dailyPlanItemArray.append(element)
                    }
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTodoTableViewCell = dailyPlanTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
        cell.configureCell(recItem: dailyPlanItemArray[indexPath.row])
        cell.todoBtn.addTarget(self, action: #selector(DailyPlanListScreenController.onClickedMapButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if dailyPlanItemArray.count == 0 {
            return []
        }
        editTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.addTodoDialog(msg: self.editTodoRec.taskDetails!)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editTodoRec.taskDetails!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deletePlanRecord(deleteActionForRowAt: indexPath, recitem: self.editTodoRec)
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        })
        deleteAction.backgroundColor = UIColor.red
        return [editAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dailyPlanItemArray.count == 0 {
            return
        }
        self.editTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTodoDialog(msg: self.editTodoRec.taskDetails!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        return dailyPlanItemArray.count
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> DailyPlanRecItem? {
        return dailyPlanItemArray[indexPath.row]
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: DailyPlanRecItem) {
        if (indexPath.section == 0) {
            dailyPlanItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            loadDailyPlanRecords()
            DispatchQueue.main.async {
                self.dailyPlanTableView.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<DailyPlanRecItem> = DailyPlanRecItem.fetchRequest()
        do {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                dailyPlanItemArray = try context.fetch(request)
                for (_, element) in dailyPlanItemArray.enumerated() {
                    if (element.timeMillis == timeMillis) {
                        context.delete(element)
                        saveContext()
                        return
                    }
                }
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                dailyPlanItemArray = try context.fetch(request)
                for (_, element) in dailyPlanItemArray.enumerated() {
                    if (element.timeMillis == timeMillis) {
                        context.delete(element)
                        saveContext()
                        return
                    }
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func createRecord() {
        if todoStr == "" {
            return
        }
        
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let plansRecItem = DailyPlanRecItem(context: context)
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.startDate = Date().string(format: "MM/dd/yyyy")
            plansRecItem.taskDetails = todoStr
            plansRecItem.completed = false
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let plansRecItem = DailyPlanRecItem()
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.startDate = Date().string(format: "MM/dd/yyyy")
            plansRecItem.taskDetails = todoStr
            plansRecItem.completed = false
        }
        saveContext()

        loadDailyPlanRecords()
        DispatchQueue.main.async {
            self.dailyPlanTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [DailyPlanRecItem]()
        let request: NSFetchRequest<DailyPlanRecItem> = DailyPlanRecItem.fetchRequest()
        do {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                updtItemArray = try context.fetch(request)
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                updtItemArray = try context.fetch(request)
            }
            
            var isFound: Bool = false
            for (_, element) in updtItemArray.enumerated() {
                if (element.timeMillis == editTodoRec.timeMillis) {
                    element.taskDetails = todoStr
                    saveContext()
                    isFound = true
                    loadDailyPlanRecords()
                    DispatchQueue.main.async {
                        self.dailyPlanTableView.reloadData() }
                    return
                }
            }
            if !isFound {
                createRecord()
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func saveContext() {
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }

    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}

extension DailyPlanListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = dailyPlanTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            dailyPlanTableView?.beginUpdates()
            dailyPlanTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = dailyPlanTableView.indexPath(for: cell) {
                dailyPlanTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
