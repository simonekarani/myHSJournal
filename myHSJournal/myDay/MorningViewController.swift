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

class MorningViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let morningRoutineArray = ["Make bed", "Get dressed", "Brush hair",
                           "Eat breakfast", "Brush teeth/wash face",  "Pack backpack",
                           "Get/Pack lunch", "Socks/shoes"]

    @IBOutlet weak var morningTableView: UITableView!
    
    var editTodoRec: MorningRecItem!
    var dailyTodoRecCount: Int!
    var todoStr: String!
    
    var morningItemArray = [MorningRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMorningRecords()
        if morningItemArray.count == 0 {
            createMorningRecords()
            loadMorningRecords()
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
        loadMorningRecords()
        DispatchQueue.main.async {
            self.morningTableView.reloadData() }
    }
    
    func setupTableView() {
        morningTableView.allowsSelection = true
        morningTableView.allowsSelectionDuringEditing = true
        
        morningTableView.delegate = self
        morningTableView.dataSource = self
        
        // Set automatic dimensions for row height
        morningTableView.estimatedRowHeight = UITableView.automaticDimension
        morningTableView.estimatedRowHeight = 600

        
        self.morningTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        morningTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
    
    func loadMorningRecords() {
        morningItemArray.removeAll()
        do {
            let request: NSFetchRequest<MorningRecItem> = MorningRecItem.fetchRequest()
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            morningItemArray = try context.fetch(request)
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTodoTableViewCell = morningTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
        cell.configureCell(recItem: morningItemArray[indexPath.row])
        cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if morningItemArray.count == 0 {
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
        if morningItemArray.count == 0 {
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
        return morningItemArray.count
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> MorningRecItem? {
        return morningItemArray[indexPath.row]
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: MorningRecItem) {
        if (indexPath.section == 0) {
            morningItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            loadMorningRecords()
            DispatchQueue.main.async {
                self.morningTableView.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<MorningRecItem> = MorningRecItem.fetchRequest()
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            morningItemArray = try context.fetch(request)
            for (_, element) in morningItemArray.enumerated() {
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
    
    func createMorningRecords() {
        for i in 0 ..< morningRoutineArray.count {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let plansRecItem = MorningRecItem(context: context)
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.routine = morningRoutineArray[i]
            plansRecItem.completed = false
            saveContext()
        }
    }
    
    func createRecord() {
        if todoStr == "" {
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let plansRecItem = MorningRecItem(context: context)
        plansRecItem.timeMillis = getCurrentMillis()
        plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
        plansRecItem.routine = todoStr
        plansRecItem.completed = false
        saveContext()

        loadMorningRecords()
        DispatchQueue.main.async {
            self.morningTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [MorningRecItem]()
        let request: NSFetchRequest<MorningRecItem> = MorningRecItem.fetchRequest()
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            updtItemArray = try context.fetch(request)
            
            var isFound: Bool = false
            for (_, element) in updtItemArray.enumerated() {
                if (element.timeMillis == editTodoRec.timeMillis) {
                    element.routine = todoStr
                    saveContext()
                    isFound = true
                    loadMorningRecords()
                    DispatchQueue.main.async {
                        self.morningTableView.reloadData() }
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

extension MorningViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: RecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = morningTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            morningTableView?.beginUpdates()
            morningTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = morningTableView.indexPath(for: cell) {
                morningTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
