//
//  BeforeHSScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class BeforeHSScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var beforeHSTableView: UITableView!
    
    var selectedSchoolYear: SchoolYearType!
    var editHSRec: HSRecItem!
    
    var hsItemArray = [HSRecItem]()
    var academicItemArray = [HSRecItem]()
    var researchItemArray = [HSRecItem]()
    var activityItemArray = [HSRecItem]()
    var academicRecCount: Int = 0
    var researchRecCount: Int = 0
    var activityRecCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHSRecords()
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHSRecords()
        DispatchQueue.main.async {
            self.beforeHSTableView.reloadData() }
    }
    
    func setupTableView() {
        beforeHSTableView.delegate = self
        beforeHSTableView.dataSource = self
        
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecTitleTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecTitleTableViewCell")
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecDetailTableViewCell")
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecNoValueTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecNoValueTableViewCell")
        
        beforeHSTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @objc private func addTapped() {
        editHSRec = nil
        performSegue(withIdentifier: "gotoYear8HsRec", sender: self)
    }

    func loadHSRecords() {
        hsItemArray.removeAll()
        academicItemArray.removeAll()
        activityItemArray.removeAll()
        researchItemArray.removeAll()
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        do {
            if #available(iOS 10.0, *) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                hsItemArray = try context.fetch(request)
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
                hsItemArray = try context.fetch(request)
            }
            
            for (_, element) in hsItemArray.enumerated() {
                if (element.schoolyear == SchoolYearType.SIXTH.description ||
                    element.schoolyear == SchoolYearType.SEVENTH.description ||
                    element.schoolyear == SchoolYearType.EIGHTH.description) {
                    
                    if (element.recType == "Academic") {
                        academicItemArray.append(element)
                    } else if (element.recType == "Extracurricular") {
                        activityItemArray.append(element)
                    } else {
                        researchItemArray.append(element)
                    }
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getRecordCount()
        if (section == 0) {
            return academicRecCount
        } else if (section == 1) {
            return researchRecCount
        } else {
            return activityRecCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("** row = \(indexPath.row) section = \(indexPath.section) count=\(indexPath.count)")
        if (indexPath.section == 0 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Academic")
            return cell
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Research / Internship / Passion Project")
            return cell
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Extracurricular Activities")
            return cell
        } else {
            if (indexPath.section == 0) {
                if academicItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.setInputView(inputScreen: "BeforeHSScreen")
                    cell.configureCell(recItem: academicItemArray[indexPath.row-1], count: academicItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Academic", count: academicItemArray.count)
                    return cell
                }
            } else if (indexPath.section == 1) {
                if researchItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.setInputView(inputScreen: "BeforeHSScreen")
                    cell.configureCell(recItem: researchItemArray[indexPath.row-1], count: researchItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Research or Internship Project", count: researchItemArray.count)
                    return cell
                }
            } else {
                if activityItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.setInputView(inputScreen: "BeforeHSScreen")
                    cell.configureCell(recItem: activityItemArray[indexPath.row-1], count: activityItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Extracurricular Activities", count: activityItemArray.count)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.section == 0 && (indexPath.row == 0 || academicItemArray.count == 0)) {
            return []
        } else if (indexPath.section == 1 && (indexPath.row == 0 || researchItemArray.count == 0)) {
            return []
        } else if (indexPath.section == 2 && (indexPath.row == 0 || activityItemArray.count == 0)) {
            return []
        }
        editHSRec = getRecord(actionForRowAt: indexPath)!
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier:"gotoYear8HsRec", sender: self.beforeHSTableView.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editHSRec.title!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteHSRecord(deleteActionForRowAt: indexPath, recitem: self.editHSRec)
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
        if (indexPath.section == 0 && (indexPath.row == 0 || academicItemArray.count == 0)) {
            return
        } else if (indexPath.section == 1 && (indexPath.row == 0 || researchItemArray.count == 0)) {
            return
        } else if (indexPath.section == 2 && (indexPath.row == 0 || activityItemArray.count == 0)) {
            return
        }
        self.editHSRec = getRecord(actionForRowAt: indexPath)!
        performSegue(withIdentifier: "gotoYear8HsRec", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() {
        // add 1 for each section heading
        academicRecCount = academicItemArray.count + 1
        if academicItemArray.count == 0 {
            academicRecCount += 1
        }
        researchRecCount = researchItemArray.count + 1
        if researchItemArray.count == 0 {
            researchRecCount += 1
        }
        activityRecCount = activityItemArray.count + 1
        if activityItemArray.count == 0 {
            activityRecCount += 1
        }
    }

    func getRecord(actionForRowAt indexPath: IndexPath) -> HSRecItem? {
        if (indexPath.section == 0) {
            return academicItemArray[indexPath.row-1]
        } else if (indexPath.section == 1) {
            return researchItemArray[indexPath.row-1]
        } else if (indexPath.section == 2) {
            return activityItemArray[indexPath.row-1]
        }
        return nil
    }
    
    func deleteHSRecord(deleteActionForRowAt indexPath: IndexPath, recitem: HSRecItem) {
        if (indexPath.section == 0) {
            academicItemArray.remove(at: indexPath.row-1)
            deleteRecord(title: recitem.title!)
            DispatchQueue.main.async {
                self.beforeHSTableView.reloadData() }
        } else if (indexPath.section == 1) {
            researchItemArray.remove(at: indexPath.row-1)
            deleteRecord(title: recitem.title!)
            DispatchQueue.main.async {
                self.beforeHSTableView.reloadData() }
        } else if (indexPath.section == 2) {
            activityItemArray.remove(at: indexPath.row-1)
            deleteRecord(title: recitem.title!)
            DispatchQueue.main.async {
                self.beforeHSTableView.reloadData() }
        }
    }
    
    func deleteRecord(title: String) {
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                hsItemArray = try context.fetch(request)
                for (_, element) in hsItemArray.enumerated() {
                    if (element.title == title) {
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
                hsItemArray = try context.fetch(request)
                for (_, element) in hsItemArray.enumerated() {
                    if (element.title == title) {
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
        if segue.destination is SchoolRecordDetailsController {
            let vc = segue.destination as? SchoolRecordDetailsController
            vc?.selectedSchoolYear = SchoolYearType.EIGHTH
            if sender != nil {
                vc?.editHSRec = self.editHSRec
            }
        }
    }
}

extension BeforeHSScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = beforeHSTableView.sizeThatFits(CGSize(width: size.width,
                                                            height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            beforeHSTableView?.beginUpdates()
            beforeHSTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = beforeHSTableView.indexPath(for: cell) {
                beforeHSTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
