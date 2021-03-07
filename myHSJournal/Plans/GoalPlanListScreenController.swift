//
//  GoalPlanListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class GoalPlanListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NoGoalMessage: String = "\nNo Goals Found.\nPlease setup Goals using the screen option - Goals"
    
    @IBOutlet weak var goalListTableView: UITableView!
    
    @IBOutlet weak var todoBtn: RoundButton!
    @IBOutlet weak var completedBtn: RoundButton!
    @IBOutlet weak var allBtn: RoundButton!
    
    var selectedSchoolYear: SchoolYearType = SchoolYearType.NINETH
    var selectedBtnTag: Int!
    var editGoalsTodoRec: GoalPlanRecItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var goalListItemArray = [GoalsRecItem]()
    var goalsTodoAllItemArray = [GoalPlanRecItem]()
    var goalsItemArray = [GoalPlanRecItem]()
    var todoView: TodoViewType!
    var todoStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView = .TODO_ACTIVE
        loadGoalsRecords()
        setupTableView()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    @objc func onPlusClickedMapButton(_ sender: UIButton) {
        selectedBtnTag = sender.tag
        addTodoDialog(msg: "")
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        saveContext()
    }
    
    @IBAction func allBtnClicked(_ sender: Any) {
        todoView = .TODO_ALL
        todoBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    @IBAction func completedBtnClicked(_ sender: Any) {
        todoView = .TODO_COMPLETED
        todoBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        allBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    @IBAction func todoBtnClicked(_ sender: Any) {
        todoView = .TODO_ACTIVE
        todoBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        completedBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allBtn.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    func addTodoDialog(msg: String) {
        var recExists = false
        let alert = UIAlertController(title: "Goals Todo", message: nil, preferredStyle: .alert)
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
        goalListTableView.allowsSelection = true
        goalListTableView.allowsSelectionDuringEditing = true
        
        goalListTableView.delegate = self
        goalListTableView.dataSource = self
        
        // Set automatic dimensions for row height
        goalListTableView.rowHeight = UITableView.automaticDimension
        goalListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.goalListTableView.register(UINib.init(nibName: "YearlySchoolYearTableViewCell", bundle: .main), forCellReuseIdentifier: "YearlySchoolYearTableViewCell")
        self.goalListTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")
        
        goalListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadGoalsRecords() {
        let gRequest: NSFetchRequest<GoalsRecItem> = GoalsRecItem.fetchRequest()
        do {
            goalListItemArray = try context.fetch(gRequest)
        } catch {
            print("Error in loading \(error)")
        }
        if goalListItemArray.count == 0 {
            createNoGoalAlertAction(message: NoGoalMessage)
        }

        goalsTodoAllItemArray.removeAll()
        goalsItemArray.removeAll()
        let request: NSFetchRequest<GoalPlanRecItem> = GoalPlanRecItem.fetchRequest()
        do {
            goalsTodoAllItemArray = try context.fetch(request)
            for (_, element) in goalsTodoAllItemArray.enumerated() {
                if todoView == TodoViewType.TODO_ALL {
                    goalsItemArray.append(element)
                }
                else if todoView == TodoViewType.TODO_ACTIVE {
                    if element.completed == false {
                        goalsItemArray.append(element)
                    }
                } else {
                    if element.completed {
                        goalsItemArray.append(element)
                    }
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("** row = \(indexPath.row) section = \(indexPath.section) count=\(indexPath.count)")
        if (indexPath.row == 0) {
            let cell: YearlySchoolYearTableViewCell = goalListTableView.dequeueReusableCell(withIdentifier: "YearlySchoolYearTableViewCell", for: indexPath) as! YearlySchoolYearTableViewCell
            cell.configureCell(section: indexPath.section, lblText: getGoalTitle(section: indexPath.section))
            cell.addBtn.addTarget(self, action: #selector(YearlyPlanListScreenController.onPlusClickedMapButton(_:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let recCount: Int = getRecordCount(numberOfRowsInSection: indexPath.section)
            if recCount > 0 {
                let cell: DailyTodoTableViewCell = goalListTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                let yearlyItem: GoalPlanRecItem = getRecord(actionForRowAt: indexPath)!
                cell.configureCell(recItem: yearlyItem)
                cell.todoBtn.addTarget(self, action: #selector(DailyPlanListScreenController.onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
            else {
                let cell: DailyTodoTableViewCell = goalListTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                cell.todoBtn.addTarget(self, action: #selector(DailyPlanListScreenController.onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.row == 0) {
            return []
        }
        editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.addTodoDialog(msg: self.editGoalsTodoRec.taskDetails!)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editGoalsTodoRec.taskDetails!)?", preferredStyle: .alert)
            
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
        if goalsItemArray.count == 0 || indexPath.row == 0 {
            return
        }
        self.editGoalsTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTodoDialog(msg: self.editGoalsTodoRec.taskDetails!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return goalListItemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getGoalTitle(section: Int) -> String {
        if goalListItemArray.count > 0 {
            return goalListItemArray[section].title!
        }
        return ""
    }
    
    func getRecordCount(numberOfRowsInSection section: Int) -> Int {
        // add 1 for each section heading
        let gItem: GoalsRecItem = goalListItemArray[section]
        var rowCount: Int = 1
        for (_, element) in goalsItemArray.enumerated() {
            if element.goalTimeMillis == gItem.timeMillis {
                rowCount += 1
            } 
        }
        return rowCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> GoalPlanRecItem? {
        let gItem: GoalsRecItem = goalListItemArray[indexPath.section]
        var recItem: GoalPlanRecItem!
        var idxCount: Int = 1
        for (_, element) in goalsItemArray.enumerated() {
            if element.goalTimeMillis == gItem.timeMillis {
                if indexPath.row == idxCount {
                    return element
                }
                idxCount += 1
            }
        }
        return recItem
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: GoalPlanRecItem) {
        deleteRecord(timeMillis: recitem.timeMillis)
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<GoalPlanRecItem> = GoalPlanRecItem.fetchRequest()
        do {
            goalsItemArray = try context.fetch(request)
            for (_, element) in goalsItemArray.enumerated() {
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
    
    func createRecord() {
        if todoStr == "" {
            return
        }
        
        let plansRecItem = GoalPlanRecItem(context: self.context)
        plansRecItem.timeMillis = getCurrentMillis()
        plansRecItem.startDate = Date().string(format: "MM/dd/yyyy")
        let sectionIdx: Int = selectedBtnTag - 2000
        let gItem: GoalsRecItem = goalListItemArray[sectionIdx]
        plansRecItem.goalStr = gItem.title
        plansRecItem.goalTimeMillis = gItem.timeMillis
        plansRecItem.taskDetails = todoStr
        plansRecItem.completed = false
        saveContext()
        
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalListTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [GoalPlanRecItem]()
        let request: NSFetchRequest<GoalPlanRecItem> = GoalPlanRecItem.fetchRequest()
        do {
            updtItemArray = try context.fetch(request)
            var isFound: Bool = false
            for (_, element) in updtItemArray.enumerated() {
                if (element.timeMillis == editGoalsTodoRec.timeMillis) {
                    element.taskDetails = todoStr
                    saveContext()
                    isFound = true
                    loadGoalsRecords()
                    DispatchQueue.main.async {
                        self.goalListTableView.reloadData() }
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

extension GoalPlanListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = goalListTableView.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            goalListTableView?.beginUpdates()
            goalListTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = goalListTableView.indexPath(for: cell) {
                goalListTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
