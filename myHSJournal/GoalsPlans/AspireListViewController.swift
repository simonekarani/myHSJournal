//
//  AspireListViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/15/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class AspireListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var aspireListTableView: UITableView!
        
    var editLetterRec: AspireRecItem!
    var letterRecCount: Int!

    var aspireItemArray = [AspireRecItem]()
    var letterItemArray = [AspireRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
        } else {
        }
        
        loadLetterRecords()
        setupTableView()
        
        if letterItemArray.count == 0 {
            editLetterRec = nil
            performSegue(withIdentifier: "gotoAspireToInspire", sender: self)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLetterRecords()
        DispatchQueue.main.async {
            self.aspireListTableView.reloadData() }
    }
    
    func setupTableView() {
        aspireListTableView.allowsSelection = true
        aspireListTableView.allowsSelectionDuringEditing = true
        
        aspireListTableView.delegate = self
        aspireListTableView.dataSource = self
        
        // Set automatic dimensions for row height
        aspireListTableView.rowHeight = UITableView.automaticDimension
        aspireListTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.aspireListTableView.register(UINib.init(nibName: "LetterRecTableViewCell", bundle: .main), forCellReuseIdentifier: "LetterRecTableViewCell")
        
        aspireListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func addTapped(_ sender: Any) {
        editLetterRec = nil
        performSegue(withIdentifier: "gotoAspireToInspire", sender: self)
    }
    
    func loadLetterRecords() {
        aspireItemArray.removeAll()
        letterItemArray.removeAll()
        let request: NSFetchRequest<AspireRecItem> = AspireRecItem.fetchRequest()
        
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                aspireItemArray = try context.fetch(request)
                for (_, element) in aspireItemArray.enumerated() {
                    letterItemArray.append(element)
                }
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                aspireItemArray = try context.fetch(request)
                for (_, element) in aspireItemArray.enumerated() {
                    letterItemArray.append(element)
                }
            } catch {
                print("Error in loading \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LetterRecTableViewCell = aspireListTableView.dequeueReusableCell(withIdentifier: "LetterRecTableViewCell", for: indexPath) as! LetterRecTableViewCell
        cell.configureCell(recItem: aspireItemArray[indexPath.row], count: letterItemArray.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if letterItemArray.count == 0 {
            return []
        }
        editLetterRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoAspireToInspire", sender: self.aspireListTableView.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record \(self.editLetterRec.aspireTo!)?", preferredStyle: .alert)
            
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
        performSegue(withIdentifier: "gotoAspireToInspire", sender: self)
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
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> AspireRecItem? {
        return letterItemArray[indexPath.row]
    }
    
    func deleteEsteemRecord(deleteActionForRowAt indexPath: IndexPath, recitem: AspireRecItem) {
        if (indexPath.section == 0) {
            letterItemArray.remove(at: indexPath.row)
            deleteRecord(timeMillis: recitem.timeMillis)
            DispatchQueue.main.async {
                self.aspireListTableView.reloadData() }
        }
    }
    
    func deleteRecord(timeMillis: Int64) {
        let request: NSFetchRequest<AspireRecItem> = AspireRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                aspireItemArray = try context.fetch(request)
                for (_, element) in aspireItemArray.enumerated() {
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
                aspireItemArray = try context.fetch(request)
                for (_, element) in aspireItemArray.enumerated() {
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
        if segue.destination is AspireInspireViewController {
            let vc = segue.destination as? AspireInspireViewController
            if sender != nil {
                vc?.editAspireRec = self.editLetterRec
                vc?.aspireRecCount = self.getRecordCount()
            }
        }
    }
}

extension AspireListViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = aspireListTableView.sizeThatFits(CGSize(width: size.width,
                                                                 height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            aspireListTableView?.beginUpdates()
            aspireListTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = aspireListTableView.indexPath(for: cell) {
                aspireListTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
