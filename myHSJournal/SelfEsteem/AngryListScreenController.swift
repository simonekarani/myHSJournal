//
//  AngryListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/19/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class AngryListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var angryTableList: UITableView!
    
    var editAngryRec: EsteemRecItem!
    var angryRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var esteemItemArray = [EsteemRecItem]()
    var angryItemArray = [EsteemRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLetterRecords()
        setupTableView()
        
        if angryItemArray.count == 0 {
            editAngryRec = nil
            performSegue(withIdentifier: "gotoAngryNote", sender: self)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLetterRecords()
        DispatchQueue.main.async {
            self.angryTableList.reloadData() }
    }
    
    func setupTableView() {
        angryTableList.allowsSelection = true
        angryTableList.allowsSelectionDuringEditing = true
        
        angryTableList.delegate = self
        angryTableList.dataSource = self
        
        // Set automatic dimensions for row height
        angryTableList.rowHeight = UITableView.automaticDimension
        angryTableList.estimatedRowHeight = UITableView.automaticDimension
        
        self.angryTableList.register(UINib.init(nibName: "AngryRecTableViewCell", bundle: .main), forCellReuseIdentifier: "AngryRecTableViewCell")
        
        angryTableList.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editAngryRec = nil
        performSegue(withIdentifier: "gotoAngryNote", sender: self)
    }
    
    func loadLetterRecords() {
        esteemItemArray.removeAll()
        angryItemArray.removeAll()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            for (_, element) in esteemItemArray.enumerated() {
                if element.esteemType == EsteemType.ANGRY.description {
                    angryItemArray.append(element)
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
        let cell: AngryRecTableViewCell = angryTableList.dequeueReusableCell(withIdentifier: "AngryRecTableViewCell", for: indexPath) as! AngryRecTableViewCell
        cell.configureCell(recItem: angryItemArray[indexPath.row], count: angryItemArray.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if angryItemArray.count == 0 {
            return []
        }
        editAngryRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoAngryNote", sender: self.angryTableList.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteEsteemRecord(deleteActionForRowAt: indexPath, recitem: self.editAngryRec)
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
        if angryItemArray.count == 0 {
            return
        }
        self.editAngryRec = getRecord(actionForRowAt: indexPath)!
        performSegue(withIdentifier: "gotoAngryNote", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        angryRecCount = angryItemArray.count
        return angryRecCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> EsteemRecItem? {
        return angryItemArray[indexPath.row]
    }
    
    func deleteEsteemRecord(deleteActionForRowAt indexPath: IndexPath, recitem: EsteemRecItem) {
        if (indexPath.section == 0) {
            angryItemArray.remove(at: indexPath.row-1)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.angryTableList.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            for (_, element) in esteemItemArray.enumerated() {
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
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AngryNoteScreenController {
            let vc = segue.destination as? AngryNoteScreenController
            if sender != nil {
                vc?.editAngryRec = self.editAngryRec
                vc?.angryRecCount = self.getRecordCount()
            }
        }
    }
}

extension AngryListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = angryTableList.sizeThatFits(CGSize(width: size.width,
                                                              height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            angryTableList?.beginUpdates()
            angryTableList?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = angryTableList.indexPath(for: cell) {
                angryTableList.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
