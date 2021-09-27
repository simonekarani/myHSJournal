//
//  MyDayRoutineViewController.swift
//  happykids
//
//  Created by Simone Karani on 8/10/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class MyDayRoutineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NoGoalMessage: String = "\nNo Safety Tips Found"

    let safetyTypeArray = ["Morning", "Afternoon", "Evening"]
    let morningRoutineArray = ["Make bed", "Get dressed", "Brush hair",
                           "Eat breakfast", "Brush teeth/wash face",  "Pack backpack",
                           "Get/Pack lunch", "Socks/shoes"]
    let afternoonRoutineArray = ["Eat lunch", "Attend class", "Homework"]
    let eveningRoutineArray = ["Eat dinner", "Homework", "40 minutes of free time",
                           "Bath/Shower", "Put on Pajamas",  "Brush teeth",
                           "Floss Teeth", "Read books", "Sleep at 10 pm"]

    @IBOutlet weak var safetyTipsTableView: UITableView!
    
    var selectedBtnTag: Int!
    var editGoalsTodoRec: DayRoutineRecItem!
    
    var goalsTodoAllItemArray = [DayRoutineRecItem]()
    var todoView: TodoViewType!
    var todoStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView = .TODO_ACTIVE
        loadRoutineRecords()
        if goalsTodoAllItemArray.count == 0 {
            createSafetyRecords()
            loadRoutineRecords()
        }
        setupTableView()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRoutineRecords()
        DispatchQueue.main.async {
            self.safetyTipsTableView.reloadData() }
    }
    
    @objc func onPlusClickedMapButton(_ sender: UIButton) {
        selectedBtnTag = sender.tag
        addTipDialog(msg: "", sType: safetyTypeArray[selectedBtnTag])
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        saveContext()
    }
    
    func addTipDialog(msg: String, sType: String) {
        var recExists = false
        let alert = UIAlertController(title: "Day Routine", message: nil, preferredStyle: .alert)
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
                self.updateRecord(safetyType: sType)
            } else {
                self.createRecord(safetyType: sType)
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupTableView() {
        safetyTipsTableView.allowsSelection = true
        safetyTipsTableView.allowsSelectionDuringEditing = true
        
        safetyTipsTableView.delegate = self
        safetyTipsTableView.dataSource = self
        
        // Set automatic dimensions for row height
        safetyTipsTableView.estimatedRowHeight = UITableView.automaticDimension
        safetyTipsTableView.estimatedRowHeight = 300

        self.safetyTipsTableView.register(UINib.init(nibName: "GoalPlanTableViewCell", bundle: .main), forCellReuseIdentifier: "GoalPlanTableViewCell")
        self.safetyTipsTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        safetyTipsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadRoutineRecords() {
        goalsTodoAllItemArray.removeAll()
        let request: NSFetchRequest<DayRoutineRecItem> = DayRoutineRecItem.fetchRequest()
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
    
    func createSafetyRecords() {
        createSafetyTipRecords(sTipArray: morningRoutineArray, sType: safetyTypeArray[0])
        createSafetyTipRecords(sTipArray: afternoonRoutineArray, sType: safetyTypeArray[1])
        createSafetyTipRecords(sTipArray: eveningRoutineArray, sType: safetyTypeArray[2])
    }
    
    func createSafetyTipRecords(sTipArray: [String], sType: String) {
        for i in 0 ..< sTipArray.count {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let tipRecItem = DayRoutineRecItem(context: context)
                tipRecItem.timeMillis = getCurrentMillis()
                tipRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
                tipRecItem.routineType = sType
                tipRecItem.routine = sTipArray[i]
                tipRecItem.completed = false
            } else {
                let tipRecItem = DayRoutineRecItem()
                tipRecItem.timeMillis = getCurrentMillis()
                tipRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
                tipRecItem.routineType = sType
                tipRecItem.routine = sTipArray[i]
                tipRecItem.completed = false
            }
            saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recCount: Int = getRecordCount(numberOfRowsInSection: indexPath.section)
        if recCount > 0 {
            if indexPath.row == 0 {
                let cell: GoalPlanTableViewCell = safetyTipsTableView.dequeueReusableCell(withIdentifier: "GoalPlanTableViewCell", for: indexPath) as! GoalPlanTableViewCell
                cell.configureCell(section: indexPath.section, lblText: getGoalTitle(section: indexPath.section))
                cell.addBtn.addTarget(self, action: #selector(onPlusClickedMapButton(_:)), for: .touchUpInside)
                cell.backgroundColor = UIColor(rgb: 0xc9c9cc)
                cell.addBtn.tag = indexPath.section
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            } else {
                let cell: DailyTodoTableViewCell = safetyTipsTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                let yearlyItem: DayRoutineRecItem = getRecord(actionForRowAt: indexPath)!
                cell.configureCell(recItem: yearlyItem)
                cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
        }
        else {
            let cell: DailyTodoTableViewCell = safetyTipsTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
            cell.todoBtn.addTarget(self, action: #selector(onClickedMapButton(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.row == 0) {
            return []
        }
        editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { [self] (action, indexPath) in
            self.addTipDialog(msg: self.editGoalsTodoRec.routine!, sType: safetyTypeArray[indexPath.section])
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editGoalsTodoRec.routine!)?", preferredStyle: .alert)
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if goalsTodoAllItemArray.count == 0 || indexPath.row == 0 {
            return
        }
        self.editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTipDialog(msg: self.editGoalsTodoRec.routine!, sType: safetyTypeArray[indexPath.section])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func getGoalTitle(section: Int) -> String {
        return safetyTypeArray[section]
    }
    
    func getRecordCount(numberOfRowsInSection section: Int) -> Int {
        let dateSection: String = safetyTypeArray[section]
        var rowCount: Int = 0
        for (_, element) in goalsTodoAllItemArray.enumerated() {
            if element.routineType == dateSection {
                rowCount += 1
            }
        }
        return rowCount+1
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> DayRoutineRecItem? {
        var idxCount: Int = 0
        let dateSection: String = safetyTypeArray[indexPath.section]
        for (_, element) in goalsTodoAllItemArray.enumerated() {
            if element.routineType == dateSection {
                if indexPath.row-1 == idxCount {
                    return element
                }
                idxCount += 1
            }
        }
        return nil
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: DayRoutineRecItem) {
        deleteRecord(timeMillis: recitem.timeMillis)
        loadRoutineRecords()
        DispatchQueue.main.async {
            self.safetyTipsTableView.reloadData() }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<DayRoutineRecItem> = DayRoutineRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                goalsTodoAllItemArray = try context.fetch(request)
                for (_, element) in goalsTodoAllItemArray.enumerated() {
                    if (element.timeMillis == timeMillis) {
                        context.delete(element)
                        saveContext()
                        return
                    }
                }
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                goalsTodoAllItemArray = try context.fetch(request)
                for (_, element) in goalsTodoAllItemArray.enumerated() {
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
    }
    
    func createRecord(safetyType: String) {
        if todoStr == "" {
            return
        }
        
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let plansRecItem = DayRoutineRecItem(context: context)
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.routineType = safetyType
            plansRecItem.routine = todoStr
            plansRecItem.completed = false
        } else {
            let plansRecItem = DayRoutineRecItem()
            plansRecItem.timeMillis = getCurrentMillis()
            plansRecItem.dateStr = Date().getFormattedDate(format: "MM/dd/yyyy")
            plansRecItem.routineType = safetyType
            plansRecItem.routine = todoStr
            plansRecItem.completed = false
        }
        
        saveContext()
        
        loadRoutineRecords()
        DispatchQueue.main.async {
            self.safetyTipsTableView.reloadData() }
    }
    
    func updateRecord(safetyType: String) {
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
                    loadRoutineRecords()
                    DispatchQueue.main.async {
                        self.safetyTipsTableView.reloadData() }
                    return
                }
            }
            if !isFound {
                createRecord(safetyType: safetyType)
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

extension MyDayRoutineViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = safetyTipsTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            safetyTipsTableView?.beginUpdates()
            safetyTipsTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = safetyTipsTableView.indexPath(for: cell) {
                safetyTipsTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
