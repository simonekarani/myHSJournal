//
//  GoalsScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/26/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class GoalsScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var goalsTableView: UITableView!
    
    var editGoalsRec: GoalsRecItem!
    var goalsRecCount: Int!
    
    var goalsItemArray = [GoalsRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGoalsRecords()
        setupTableView()
        
        if goalsItemArray.count == 0 {
            editGoalsRec = nil
            performSegue(withIdentifier: "gotoGoalsNote", sender: self)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGoalsRecords()
        DispatchQueue.main.async {
            self.goalsTableView.reloadData() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        print(goalsItemArray)
    }

    func setupTableView() {
        goalsTableView.allowsSelection = true
        goalsTableView.allowsSelectionDuringEditing = true
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        // Set automatic dimensions for row height
        goalsTableView.rowHeight = UITableView.automaticDimension
        goalsTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.goalsTableView.register(UINib.init(nibName: "GoalsListTableViewCell", bundle: .main), forCellReuseIdentifier: "GoalsListTableViewCell")
        
        goalsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editGoalsRec = nil
        performSegue(withIdentifier: "gotoGoalsNote", sender: self)
    }
    
    func loadGoalsRecords() {
        goalsItemArray.removeAll()
        let request: NSFetchRequest<GoalsRecItem> = GoalsRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                goalsItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                goalsItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalsListTableViewCell = goalsTableView.dequeueReusableCell(withIdentifier: "GoalsListTableViewCell", for: indexPath) as! GoalsListTableViewCell
        cell.configureCell(recItem: goalsItemArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if goalsItemArray.count == 0 {
            return []
        }
        editGoalsRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoGoalsNote", sender: self.goalsTableView.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editGoalsRec.title!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteGoalsRecord(deleteActionForRowAt: indexPath, recitem: self.editGoalsRec)
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
        if goalsItemArray.count == 0 {
            return
        }
        self.editGoalsRec = getRecord(actionForRowAt: indexPath)!
        performSegue(withIdentifier: "gotoGoalsNote", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        goalsRecCount = goalsItemArray.count
        return goalsRecCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> GoalsRecItem? {
        return goalsItemArray[indexPath.row]
    }
    
    func deleteGoalsRecord(deleteActionForRowAt indexPath: IndexPath, recitem: GoalsRecItem) {
        if (indexPath.section == 0) {
            goalsItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.goalsTableView.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<GoalsRecItem> = GoalsRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GoalsNoteScreenController {
            let vc = segue.destination as? GoalsNoteScreenController
            if sender != nil {
                vc?.editGoalsRec = self.editGoalsRec
                vc?.goalsRecCount = self.getRecordCount()
            }
        }
    }
}

extension GoalsScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = goalsTableView.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            goalsTableView?.beginUpdates()
            goalsTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = goalsTableView.indexPath(for: cell) {
                goalsTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
