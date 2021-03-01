//
//  FeelingListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/20/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class FeelingListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var feelingTableViewList: UITableView!
    
    var editFeelingRec: EsteemRecItem!
    var feelingRecCount: Int!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var esteemItemArray = [EsteemRecItem]()
    var feelingItemArray = [EsteemRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLetterRecords()
        setupTableView()
        
        if feelingItemArray.count == 0 {
            editFeelingRec = nil
            performSegue(withIdentifier: "gotoFeelNote", sender: self)
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
            self.feelingTableViewList.reloadData() }
    }
    
    func setupTableView() {
        feelingTableViewList.allowsSelection = true
        feelingTableViewList.allowsSelectionDuringEditing = true
        
        feelingTableViewList.delegate = self
        feelingTableViewList.dataSource = self
        
        // Set automatic dimensions for row height
        feelingTableViewList.rowHeight = UITableView.automaticDimension
        feelingTableViewList.estimatedRowHeight = UITableView.automaticDimension
        
        self.feelingTableViewList.register(UINib.init(nibName: "FeelingRecTableViewCell", bundle: .main), forCellReuseIdentifier: "FeelingRecTableViewCell")
        
        feelingTableViewList.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editFeelingRec = nil
        performSegue(withIdentifier: "gotoFeelNote", sender: self)
    }
    
    func loadLetterRecords() {
        esteemItemArray.removeAll()
        feelingItemArray.removeAll()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            for (_, element) in esteemItemArray.enumerated() {
                if element.esteemType == EsteemType.FEELING.description {
                    feelingItemArray.append(element)
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
        let cell: FeelingRecTableViewCell = feelingTableViewList.dequeueReusableCell(withIdentifier: "FeelingRecTableViewCell", for: indexPath) as! FeelingRecTableViewCell
        cell.configureCell(recItem: feelingItemArray[indexPath.row], count: feelingItemArray.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if feelingItemArray.count == 0 {
            return []
        }
        editFeelingRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoFeelNote", sender: self.feelingTableViewList.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editFeelingRec.msgTitle!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteEsteemRecord(deleteActionForRowAt: indexPath, recitem: self.editFeelingRec)
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
        if feelingItemArray.count == 0 {
            return
        }
        self.editFeelingRec = getRecord(actionForRowAt: indexPath)!
        performSegue(withIdentifier: "gotoFeelNote", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        feelingRecCount = feelingItemArray.count
        return feelingRecCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> EsteemRecItem? {
        return feelingItemArray[indexPath.row]
    }
    
    func deleteEsteemRecord(deleteActionForRowAt indexPath: IndexPath, recitem: EsteemRecItem) {
        if (indexPath.section == 0) {
            feelingItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.feelingTableViewList.reloadData() }
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
        if segue.destination is FeelingNoteScreenController {
            let vc = segue.destination as? FeelingNoteScreenController
            if sender != nil {
                vc?.editEsteemRec = self.editFeelingRec
                vc?.esteemRecCount = self.getRecordCount()
            }
        }
    }
}

extension FeelingListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = feelingTableViewList.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            feelingTableViewList?.beginUpdates()
            feelingTableViewList?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = feelingTableViewList.indexPath(for: cell) {
                feelingTableViewList.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
