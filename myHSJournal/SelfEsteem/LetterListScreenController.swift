//
//  LetterListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/15/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class LetterListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var letterListTableView: UITableView!
    
    var editLetterRec: EsteemRecItem!
    var letterRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var esteemItemArray = [EsteemRecItem]()
    var letterItemArray = [EsteemRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLetterRecords()
        setupTableView()
        
        if letterItemArray.count == 0 {
            editLetterRec = nil
            performSegue(withIdentifier: "gotoFriendNote", sender: self)
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
            self.letterListTableView.reloadData() }
    }
    
    func setupTableView() {
        letterListTableView.allowsSelection = true
        letterListTableView.allowsSelectionDuringEditing = true
        
        letterListTableView.delegate = self
        letterListTableView.dataSource = self
        
        // Set automatic dimensions for row height
        letterListTableView.rowHeight = UITableView.automaticDimension
        letterListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.letterListTableView.register(UINib.init(nibName: "LetterRecTableViewCell", bundle: .main), forCellReuseIdentifier: "LetterRecTableViewCell")
        
        letterListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editLetterRec = nil
        performSegue(withIdentifier: "gotoFriendNote", sender: self)
    }
    
    func loadLetterRecords() {
        esteemItemArray.removeAll()
        letterItemArray.removeAll()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            for (_, element) in esteemItemArray.enumerated() {
                if element.esteemType == EsteemType.LETTER.description {
                    letterItemArray.append(element)
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
        let cell: LetterRecTableViewCell = letterListTableView.dequeueReusableCell(withIdentifier: "LetterRecTableViewCell", for: indexPath) as! LetterRecTableViewCell
        cell.configureCell(recItem: letterItemArray[indexPath.row], count: letterItemArray.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if letterItemArray.count == 0 {
            return []
        }
        editLetterRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoFriendNote", sender: self.letterListTableView.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editLetterRec.msgTitle!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteEsteemRecord(deleteActionForRowAt: indexPath, recitem: self.editLetterRec)
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
        if letterItemArray.count == 0 {
            return
        }
        self.editLetterRec = getRecord(actionForRowAt: indexPath)!
        performSegue(withIdentifier: "gotoFriendNote", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        letterRecCount = letterItemArray.count
        return letterRecCount
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> EsteemRecItem? {
        return letterItemArray[indexPath.row]
    }
    
    func deleteEsteemRecord(deleteActionForRowAt indexPath: IndexPath, recitem: EsteemRecItem) {
        if (indexPath.section == 0) {
            letterItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.letterListTableView.reloadData() }
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
        if segue.destination is LetterFriendScreenController {
            let vc = segue.destination as? LetterFriendScreenController
            if sender != nil {
                vc?.editEsteemRec = self.editLetterRec
                vc?.esteemRecCount = self.getRecordCount()
            }
        }
    }
}

extension LetterListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = letterListTableView.sizeThatFits(CGSize(width: size.width,
                                                                 height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            letterListTableView?.beginUpdates()
            letterListTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = letterListTableView.indexPath(for: cell) {
                letterListTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
