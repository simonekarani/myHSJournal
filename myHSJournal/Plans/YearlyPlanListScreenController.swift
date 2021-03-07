//
//  YearlyPlanListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class YearlyPlanListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var yearlyTodoTableView: UITableView!
    
    @IBOutlet weak var allYearlyButton: RoundButton!
    @IBOutlet weak var completedYearlyButton: RoundButton!
    @IBOutlet weak var todoYearlyButton: RoundButton!
    
    var selectedSchoolYear: SchoolYearType = SchoolYearType.NINETH
    var selectedBtnTag: Int!
    var editYearlyTodoRec: YearlyPlanRecItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var yearlyTodoAllItemArray = [YearlyPlanRecItem]()
    var yearlyItemArray = [YearlyPlanRecItem]()
    var todoView: TodoViewType!
    var todoStr: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView = .TODO_ACTIVE
        loadYearlyRecords()
        setupTableView()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }

    @objc func onPlusClickedMapButton(_ sender: UIButton) {
        selectedBtnTag = sender.tag
        addTodoDialog(msg: "")
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        saveContext()
    }
    
    @IBAction func allButtonClicked(_ sender: Any) {
        todoView = .TODO_ALL
        todoYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allYearlyButton.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }

    @IBAction func completedButtonClicked(_ sender: Any) {
        todoView = .TODO_COMPLETED
        todoYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        completedYearlyButton.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        allYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }

    @IBAction func todoButtonClicked(_ sender: Any) {
        todoView = .TODO_ACTIVE
        todoYearlyButton.backgroundColor = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        completedYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        allYearlyButton.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }
    
    func addTodoDialog(msg: String) {
        var recExists = false
        let alert = UIAlertController(title: "Yearly Todo", message: nil, preferredStyle: .alert)
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
        yearlyTodoTableView.allowsSelection = true
        yearlyTodoTableView.allowsSelectionDuringEditing = true
        
        yearlyTodoTableView.delegate = self
        yearlyTodoTableView.dataSource = self
        
        // Set automatic dimensions for row height
        yearlyTodoTableView.rowHeight = UITableView.automaticDimension
        yearlyTodoTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.yearlyTodoTableView.register(UINib.init(nibName: "YearlySchoolYearTableViewCell", bundle: .main), forCellReuseIdentifier: "YearlySchoolYearTableViewCell")
        self.yearlyTodoTableView.register(UINib.init(nibName: "DailyTodoTableViewCell", bundle: .main), forCellReuseIdentifier: "DailyTodoTableViewCell")

        yearlyTodoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editYearlyTodoRec = nil
        performSegue(withIdentifier: "gotoAchievementsRec", sender: self)
    }
    
    func loadYearlyRecords() {
        yearlyTodoAllItemArray.removeAll()
        yearlyItemArray.removeAll()
        let request: NSFetchRequest<YearlyPlanRecItem> = YearlyPlanRecItem.fetchRequest()
        do {
            yearlyTodoAllItemArray = try context.fetch(request)
            for (_, element) in yearlyTodoAllItemArray.enumerated() {
                if todoView == TodoViewType.TODO_ALL {
                    yearlyItemArray.append(element)
                }
                else if todoView == TodoViewType.TODO_ACTIVE {
                    if element.completed == false {
                        yearlyItemArray.append(element)
                    }
                } else {
                    if element.completed {
                        yearlyItemArray.append(element)
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
            let cell: YearlySchoolYearTableViewCell = yearlyTodoTableView.dequeueReusableCell(withIdentifier: "YearlySchoolYearTableViewCell", for: indexPath) as! YearlySchoolYearTableViewCell
            cell.configureCell(section: indexPath.section)
            cell.addBtn.addTarget(self, action: #selector(YearlyPlanListScreenController.onPlusClickedMapButton(_:)), for: .touchUpInside)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let recCount: Int = getRecordCount(numberOfRowsInSection: indexPath.section)
            if recCount > 0 {
                let cell: DailyTodoTableViewCell = yearlyTodoTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                let yearlyItem: YearlyPlanRecItem = getRecord(actionForRowAt: indexPath)!
                cell.configureCell(recItem: yearlyItem)
                cell.todoBtn.addTarget(self, action: #selector(DailyPlanListScreenController.onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
            else {
                let cell: DailyTodoTableViewCell = yearlyTodoTableView.dequeueReusableCell(withIdentifier: "DailyTodoTableViewCell", for: indexPath) as! DailyTodoTableViewCell
                cell.todoBtn.addTarget(self, action: #selector(DailyPlanListScreenController.onClickedMapButton(_:)), for: .touchUpInside)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.row == 0) {
            return []
        }
        editYearlyTodoRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.addTodoDialog(msg: self.editYearlyTodoRec.yearlyDetails!)
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editYearlyTodoRec.yearlyDetails!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deletePlanRecord(deleteActionForRowAt: indexPath, recitem: self.editYearlyTodoRec)
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
        if yearlyItemArray.count == 0 {
            return
        }
        self.editYearlyTodoRec = getRecord(actionForRowAt: indexPath)!
        self.addTodoDialog(msg: self.editYearlyTodoRec.yearlyDetails!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount(numberOfRowsInSection section: Int) -> Int {
        // add 1 for each section heading
        var sec0Count: Int = 1
        var sec1Count: Int = 1
        var sec2Count: Int = 1
        var sec3Count: Int = 1
        for (_, element) in yearlyItemArray.enumerated() {
            if section == 0 && element.yearType == SchoolYearType.NINETH.description {
                sec0Count += 1
            } else if section == 1 && element.yearType == SchoolYearType.TENTH.description {
                sec1Count += 1
            } else if section == 2 && element.yearType == SchoolYearType.ELEVENTH.description {
                sec2Count += 1
            } else if section == 3 && element.yearType == SchoolYearType.TWELVETH.description {
                sec3Count += 1
            }
        }
        
        if section == 0 {
            return sec0Count
        } else if section == 1 {
            return sec1Count
        } else if section == 2 {
            return sec2Count
        } else {
            return sec3Count
        }
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> YearlyPlanRecItem? {
        var recItem: YearlyPlanRecItem!
        var idxCount: Int = 1
        for (_, element) in yearlyItemArray.enumerated() {
            if indexPath.section == 0 && element.yearType == SchoolYearType.NINETH.description {
                if indexPath.row == idxCount {
                    return element
                }
                idxCount += 1
            } else if indexPath.section == 1 && element.yearType == SchoolYearType.TENTH.description {
                if indexPath.row == idxCount {
                    return element
                }
                idxCount += 1
            } else if indexPath.section == 2 && element.yearType == SchoolYearType.ELEVENTH.description {
                if indexPath.row == idxCount {
                    return element
                }
                idxCount += 1
            } else if indexPath.section == 3 && element.yearType == SchoolYearType.TWELVETH.description {
                if indexPath.row == idxCount {
                    return element
                }
                idxCount += 1
            }
        }
        return recItem
    }
    
    func deletePlanRecord(deleteActionForRowAt indexPath: IndexPath, recitem: YearlyPlanRecItem) {
        deleteRecord(timeMillis: recitem.timeMillis)
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<YearlyPlanRecItem> = YearlyPlanRecItem.fetchRequest()
        do {
            yearlyItemArray = try context.fetch(request)
            for (_, element) in yearlyItemArray.enumerated() {
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
        
        let plansRecItem = YearlyPlanRecItem(context: self.context)
        plansRecItem.timeMillis = getCurrentMillis()
        plansRecItem.startDate = Date().string(format: "MM/dd/yyyy")
        if (selectedBtnTag == 1001) {
            plansRecItem.yearType = SchoolYearType.NINETH.description
        } else if (selectedBtnTag == 1002) {
            plansRecItem.yearType = SchoolYearType.TENTH.description
        } else if (selectedBtnTag == 1003) {
            plansRecItem.yearType = SchoolYearType.ELEVENTH.description
        } else {
            plansRecItem.yearType = SchoolYearType.TWELVETH.description
        }
        plansRecItem.yearlyDetails = todoStr
        plansRecItem.completed = false
        saveContext()
        
        loadYearlyRecords()
        DispatchQueue.main.async {
            self.yearlyTodoTableView.reloadData() }
    }
    
    func updateRecord() {
        var updtItemArray = [YearlyPlanRecItem]()
        let request: NSFetchRequest<YearlyPlanRecItem> = YearlyPlanRecItem.fetchRequest()
        do {
            updtItemArray = try context.fetch(request)
            var isFound: Bool = false
            for (_, element) in updtItemArray.enumerated() {
                if (element.timeMillis == editYearlyTodoRec.timeMillis) {
                    element.yearlyDetails = todoStr
                    saveContext()
                    isFound = true
                    loadYearlyRecords()
                    DispatchQueue.main.async {
                        self.yearlyTodoTableView.reloadData() }
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

extension YearlyPlanListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = yearlyTodoTableView.sizeThatFits(CGSize(width: size.width,
                                                                 height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            yearlyTodoTableView?.beginUpdates()
            yearlyTodoTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = yearlyTodoTableView.indexPath(for: cell) {
                yearlyTodoTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
