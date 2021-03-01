//
//  AnxietyListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/21/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class AnxietyListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var anxietyListTableView: UITableView!
    
    var editAnxietyRec: EsteemRecItem!
    var anxietyRecCount: Int!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var esteemItemArray = [EsteemRecItem]()
    var anxietyItemArray = [EsteemRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAnxietyRecords()
        setupTableView()
        
        editAnxietyRec = nil
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAnxietyRecords()
        DispatchQueue.main.async {
            self.anxietyListTableView.reloadData() }
    }
    
    func setupTableView() {
        anxietyListTableView.allowsSelection = true
        anxietyListTableView.allowsSelectionDuringEditing = true
        
        anxietyListTableView.delegate = self
        anxietyListTableView.dataSource = self
        
        // Set automatic dimensions for row height
        anxietyListTableView.rowHeight = UITableView.automaticDimension
        anxietyListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.anxietyListTableView.register(UINib.init(nibName: "FeelingRecTableViewCell", bundle: .main), forCellReuseIdentifier: "FeelingRecTableViewCell")
        self.anxietyListTableView.register(UINib.init(nibName: "AngryRecTableViewCell", bundle: .main), forCellReuseIdentifier: "AngryRecTableViewCell")
        self.anxietyListTableView.register(UINib.init(nibName: "LetterRecTableViewCell", bundle: .main), forCellReuseIdentifier: "LetterRecTableViewCell")

        anxietyListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadAnxietyRecords() {
        esteemItemArray.removeAll()
        anxietyItemArray.removeAll()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            for (_, element) in esteemItemArray.enumerated() {
                anxietyItemArray.append(element)
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (anxietyItemArray[indexPath.row].esteemType == EsteemType.LETTER.description) {
            let cell: LetterRecTableViewCell = anxietyListTableView.dequeueReusableCell(withIdentifier: "LetterRecTableViewCell", for: indexPath) as! LetterRecTableViewCell
            cell.configureCell(recItem: anxietyItemArray[indexPath.row], count: anxietyItemArray.count)
            return cell
        } else if (anxietyItemArray[indexPath.row].esteemType == EsteemType.FEELING.description) {
            let cell: FeelingRecTableViewCell = anxietyListTableView.dequeueReusableCell(withIdentifier: "FeelingRecTableViewCell", for: indexPath) as! FeelingRecTableViewCell
            cell.configureCell(recItem: anxietyItemArray[indexPath.row], count: anxietyItemArray.count)
            return cell
        } else {
            let cell: AngryRecTableViewCell = anxietyListTableView.dequeueReusableCell(withIdentifier: "AngryRecTableViewCell", for: indexPath) as! AngryRecTableViewCell
            cell.configureCell(recItem: anxietyItemArray[indexPath.row], count: anxietyItemArray.count)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if anxietyItemArray.count == 0 {
            return []
        }
        var editAction:UITableViewRowAction!
        editAnxietyRec = getRecord(actionForRowAt: indexPath)!
        if (editAnxietyRec.esteemType == EsteemType.ANGRY.description) {
            editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                self.performSegue(withIdentifier:"gotoAnxietyAngry", sender: self.anxietyListTableView.cellForRow(at: indexPath))
            })
            editAction.backgroundColor = UIColor.blue
        } else if (editAnxietyRec.esteemType == EsteemType.LETTER.description) {
            editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                self.performSegue(withIdentifier:"gotoAnxietyFriend", sender: self.anxietyListTableView.cellForRow(at: indexPath))
            })
            editAction.backgroundColor = UIColor.blue
        } else if (editAnxietyRec.esteemType == EsteemType.FEELING.description) {
            let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                self.performSegue(withIdentifier:"gotoAnxietyFeel", sender: self.anxietyListTableView.cellForRow(at: indexPath))
            })
            editAction.backgroundColor = UIColor.blue
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editAnxietyRec.msgTitle!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteEsteemRecord(deleteActionForRowAt: indexPath, recitem: self.editAnxietyRec)
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
        if anxietyItemArray.count == 0 {
            return
        }
        self.editAnxietyRec = getRecord(actionForRowAt: indexPath)!
        if (editAnxietyRec.esteemType == EsteemType.ANGRY.description) {
            performSegue(withIdentifier: "gotoAnxietyAngry", sender: self)
        } else if (editAnxietyRec.esteemType == EsteemType.LETTER.description) {
            performSegue(withIdentifier: "gotoAnxietyFriend", sender: self)
        } else if (editAnxietyRec.esteemType == EsteemType.FEELING.description) {
            performSegue(withIdentifier: "gotoAnxietyFeel", sender: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        anxietyRecCount = anxietyItemArray.count
        return anxietyRecCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> EsteemRecItem? {
        return anxietyItemArray[indexPath.row]
    }
    
    func deleteEsteemRecord(deleteActionForRowAt indexPath: IndexPath, recitem: EsteemRecItem) {
        if (indexPath.section == 0) {
            anxietyItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.anxietyListTableView.reloadData() }
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
        if (editAnxietyRec.esteemType == EsteemType.ANGRY.description) {
            if segue.destination is AngryNoteScreenController {
                let vc = segue.destination as? AngryNoteScreenController
                if sender != nil {
                    vc?.editEsteemRec = self.editAnxietyRec
                    vc?.esteemRecCount = self.getRecordCount()
                }
            }
        } else if (editAnxietyRec.esteemType == EsteemType.LETTER.description) {
            if segue.destination is LetterFriendScreenController {
                let vc = segue.destination as? LetterFriendScreenController
                if sender != nil {
                    vc?.editEsteemRec = self.editAnxietyRec
                    vc?.esteemRecCount = self.getRecordCount()
                }
            }
        } else {
            if segue.destination is FeelingNoteScreenController {
                let vc = segue.destination as? FeelingNoteScreenController
                if sender != nil {
                    vc?.editEsteemRec = self.editAnxietyRec
                    vc?.esteemRecCount = self.getRecordCount()
                }
            }
        }
    }
}

extension AnxietyListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = anxietyListTableView.sizeThatFits(CGSize(width: size.width,
                                                               height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            anxietyListTableView?.beginUpdates()
            anxietyListTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = anxietyListTableView.indexPath(for: cell) {
                anxietyListTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
