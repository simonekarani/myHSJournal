//
//  DeedsViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class DeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NoGoalMessage: String = "\nNo Good Deeds Found"
    
    @IBOutlet weak var deedsTableView: UITableView!
    
    var selectedBtnTag: Int!
    var editGoalsTodoRec: DeedsRecItem!
    
    var goalsTodoAllItemArray = [DeedsRecItem]()
    var deedsList = [String]()
    var todoView: TodoViewType!
    var todoStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView = .TODO_ACTIVE
        loadDeedsRecords()
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
        loadDeedsRecords()
        DispatchQueue.main.async {
            self.deedsTableView.reloadData() }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addTodoDialog(msg: "")
    }
    
    @objc func onPlusClickedMapButton(_ sender: UIButton) {
        selectedBtnTag = sender.tag
        addTodoDialog(msg: "")
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        saveContext()
    }
    
    func addTodoDialog(msg: String) {
        var recExists = false
        let alert = UIAlertController(title: "Good Deeds", message: nil, preferredStyle: .alert)
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
    
    func setupTableView() {
        deedsTableView.allowsSelection = true
        deedsTableView.allowsSelectionDuringEditing = true
        
        deedsTableView.delegate = self
        deedsTableView.dataSource = self
        
        // Set automatic dimensions for row height
        deedsTableView.estimatedRowHeight = UITableView.automaticDimension
        deedsTableView.estimatedRowHeight = 600

        self.deedsTableView.register(UINib.init(nibName: "GoalPlanTableViewCell", bundle: .main), forCellReuseIdentifier: "GoalPlanTableViewCell")
        self.deedsTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        deedsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadDeedsRecords() {
        goalsTodoAllItemArray.removeAll()
        let request: NSFetchRequest<DeedsRecItem> = DeedsRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                goalsTodoAllItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                goalsTodoAllItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (goalsTodoAllItemArray.count == 0) {
            let cell: GoalPlanTableViewCell = deedsTableView.dequeueReusableCell(withIdentifier: "GoalPlanTableViewCell", for: indexPath) as! GoalPlanTableViewCell
            cell.configureCell(section: indexPath.section, lblText: getGoalTitle(section: indexPath.section))
            cell.backgroundColor = UIColor(hex: "c9c9cc")
            cell.addBtn.addTarget(self, action: #selector(onPlusClickedMapButton(_:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        let recCount: Int = getRecordCount(numberOfRowsInSection: indexPath.section)
        if recCount > 0 {
            if indexPath.row == 0 {
                let cell: GoalPlanTableViewCell = deedsTableView.dequeueReusableCell(withIdentifier: "GoalPlanTableViewCell", for: indexPath) as! GoalPlanTableViewCell
                cell.configureCell(section: indexPath.section, lblText: getGoalTitle(section: indexPath.section))
                cell.backgroundColor = UIColor(hex: "c9c9cc")
                cell.addBtn.addTarget(self, action: #selector(onPlusClickedMapButton(_:)), for: .touchUpInside)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                let cell: DailyTodoTableViewCell = deedsTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                let yearlyItem: DeedsRecItem = getRecord(actionForRowAt: indexPath)!
                cell.configureCell(recItem: yearlyItem)
                cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
        }
        else {
            let cell: DailyTodoTableViewCell = deedsTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
            cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.row == 0) {
            return []
        }
        editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.addTodoDialog(msg: self.editGoalsTodoRec.deedDetails!)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editGoalsTodoRec.deedDetails!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deletePlanRecord(deleteActionForRowAt: indexPath, recitem: self.editGoalsTodoRec)
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
    
    func createNoGoalAlertAction(message: String) {
        let alert = UIAlertController(title: "Plans for Goals!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)

        })))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if goalsTodoAllItemArray.count == 0 || indexPath.row == 0 {
            return
        }
        self.editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTodoDialog(msg: self.editGoalsTodoRec.deedDetails!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if goalsTodoAllItemArray.count == 0 {
            return 1
        } else {
            var goodDeedSet = Set<String>()
            for elem in goalsTodoAllItemArray {
                goodDeedSet.insert(elem.dateStr!)
            }
            deedsList = Array(goodDeedSet)
            return deedsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getGoalTitle(section: Int) -> String {
        let dateValue:String = Date().getFormattedDate(format: "MM/dd/yyyy")
        if goalsTodoAllItemArray.count == 0 {
            return "TODAY - " + dateValue
        } else {
            if dateValue == goalsTodoAllItemArray[section].dateStr! {
                return "TODAY - " + dateValue
            }
            return goalsTodoAllItemArray[section].dateStr!
        }
    }
    
    func getRecordCount(numberOfRowsInSection section: Int) -> Int {
        // add 1 for each section heading
        if goalsTodoAllItemArray.count == 0 {
            return 1
        }
        let dateSection: String = deedsList[section]
        var rowCount: Int = 1
        for (_, element) in goalsTodoAllItemArray.enumerated() {
            if element.dateStr == dateSection {
                rowCount += 1
            }
        }
        return rowCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> DeedsRecItem? {
        var idxCount: Int = 0
        let dateSection: String = deedsList[indexPath.section]
        for (_, element) in goalsTodoAllItemArray.enumerated() {
            if element.dateStr == dateSection {
                if indexPath.row-1 == idxCount {
                    return element
                }
                idxCount += 1
            }
        }
        return nil
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: DeedsRecItem) {
        deleteRecord(timeMillis: recitem.timeMillis)
        loadDeedsRecords()
        DispatchQueue.main.async {
            self.deedsTableView.reloadData() }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<DeedsRecItem> = DeedsRecItem.fetchRequest()
        do {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                goalsTodoAllItemArray = try context.fetch(request)

                for (_, element) in goalsTodoAllItemArray.enumerated() {
                    if (element.timeMillis == timeMillis) {
                        context.delete(element)
                        saveContext()
                        return
                    }
                }
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                goalsTodoAllItemArray = try context.fetch(request)

                for (_, element) in goalsTodoAllItemArray.enumerated() {
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
            let plansRecItem = DeedsRecItem(context: context)
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.deedDetails = todoStr
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let plansRecItem = DeedsRecItem()
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.deedDetails = todoStr
        }
        
        saveContext()
        
        loadDeedsRecords()
        DispatchQueue.main.async {
            self.deedsTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [GoalPlanRecItem]()
        let request: NSFetchRequest<GoalPlanRecItem> = GoalPlanRecItem.fetchRequest()
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
                if (element.timeMillis == editGoalsTodoRec.timeMillis) {
                    element.taskDetails = todoStr
                    saveContext()
                    isFound = true
                    loadDeedsRecords()
                    DispatchQueue.main.async {
                        self.deedsTableView.reloadData() }
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

extension DeedsViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = deedsTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            deedsTableView?.beginUpdates()
            deedsTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = deedsTableView.indexPath(for: cell) {
                deedsTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
