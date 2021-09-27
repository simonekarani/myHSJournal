//
//  MorningViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class EveningViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let eveningRoutineArray = ["Eat dinner", "Homework", "40 minutes of free time",
                           "Bath/Shower", "Put on Pajamas",  "Brush teeth",
                           "Floss Teeth", "Read books", "Sleep at 10 pm"]
    
    @IBOutlet weak var eveningTableView: UITableView!
    
    var editTodoRec: EveningRecItem!
    var dailyTodoRecCount: Int!
    var todoStr: String!
    
    var eveningItemArray = [EveningRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEveningRecords()
        if eveningItemArray.count == 0 {
            createEveningRecords()
            loadEveningRecords()
        }
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadEveningRecords()
        DispatchQueue.main.async {
            self.eveningTableView.reloadData() }
    }
    
    func setupTableView() {
        eveningTableView.allowsSelection = true
        eveningTableView.allowsSelectionDuringEditing = true
        
        eveningTableView.delegate = self
        eveningTableView.dataSource = self
        
        // Set automatic dimensions for row height
        eveningTableView.estimatedRowHeight = UITableView.automaticDimension
        eveningTableView.estimatedRowHeight = 600
        
        self.eveningTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        eveningTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addTodoDialog(msg: "")
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        saveContext()
    }

    func addTodoDialog(msg: String) {
        var recExists = false
        let alert = UIAlertController(title: "Morning Routine", message: nil, preferredStyle: .alert)
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
    
    func loadEveningRecords() {
        eveningItemArray.removeAll()
        do {
            let request: NSFetchRequest<EveningRecItem> = EveningRecItem.fetchRequest()
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            eveningItemArray = try context.fetch(request)
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTodoTableViewCell = eveningTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
        cell.configureCell(recItem: eveningItemArray[indexPath.row])
        cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if eveningItemArray.count == 0 {
            return []
        }
        editTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.addTodoDialog(msg: self.editTodoRec.routine!)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editTodoRec.routine!)?", preferredStyle: .alert)
            
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
        if eveningItemArray.count == 0 {
            return
        }
        self.editTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTodoDialog(msg: self.editTodoRec.routine!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        return eveningItemArray.count
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> EveningRecItem? {
        return eveningItemArray[indexPath.row]
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: EveningRecItem) {
        if (indexPath.section == 0) {
            eveningItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            loadEveningRecords()
            DispatchQueue.main.async {
                self.eveningTableView.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<EveningRecItem> = EveningRecItem.fetchRequest()
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            eveningItemArray = try context.fetch(request)
            for (_, element) in eveningItemArray.enumerated() {
                if (element.timeMillis == timeMillis) {
                    context.delete(element)
                    saveContext()
                    return
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func createEveningRecords() {
        for i in 0 ..< eveningRoutineArray.count {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let plansRecItem = EveningRecItem(context: context)
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.routine = eveningRoutineArray[i]
            plansRecItem.completed = false
            saveContext()
        }
    }
    
    func createRecord() {
        if todoStr == "" {
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let plansRecItem = EveningRecItem(context: context)
        plansRecItem.timeMillis = getCurrentMillis()
        plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
        plansRecItem.routine = todoStr
        plansRecItem.completed = false
        saveContext()

        loadEveningRecords()
        DispatchQueue.main.async {
            self.eveningTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [EveningRecItem]()
        let request: NSFetchRequest<EveningRecItem> = EveningRecItem.fetchRequest()
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            updtItemArray = try context.fetch(request)
            
            var isFound: Bool = false
            for (_, element) in updtItemArray.enumerated() {
                if (element.timeMillis == editTodoRec.timeMillis) {
                    element.routine = todoStr
                    saveContext()
                    isFound = true
                    loadEveningRecords()
                    DispatchQueue.main.async {
                        self.eveningTableView.reloadData() }
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}

extension EveningViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: RecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = eveningTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            eveningTableView?.beginUpdates()
            eveningTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = eveningTableView.indexPath(for: cell) {
                eveningTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
