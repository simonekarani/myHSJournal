//
//  MyAchievementScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class MyAchievementScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myAchievementTableView: UITableView!
    
    var selectedSchoolYear: SchoolYearType!
    var editHSRec: HSRecItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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

    func setupTableView() {
        myAchievementTableView.delegate = self
        myAchievementTableView.dataSource = self
        
        self.myAchievementTableView.register(UINib.init(nibName: "HSRecTitleTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecTitleTableViewCell")
        self.myAchievementTableView.register(UINib.init(nibName: "HSRecDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecDetailTableViewCell")
        self.myAchievementTableView.register(UINib.init(nibName: "HSRecNoValueTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecNoValueTableViewCell")
        
        myAchievementTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    @IBAction func addTapped(_ sender: Any) {
        editHSRec = nil
        performSegue(withIdentifier: "gotoAchievementsRec", sender: self)
    }
    
    func loadHSRecords() {
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        do {
            hsItemArray = try context.fetch(request)
            for (index, element) in hsItemArray.enumerated() {
                print(index, ":", element)
                if (element.recType == "Academic") {
                    academicItemArray.append(element)
                } else if (element.recType == "Extracurricular") {
                    activityItemArray.append(element)
                } else {
                    researchItemArray.append(element)
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
            let cell: HSRecTitleTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Academic")
            return cell
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Research / Internship / Passion Project")
            return cell
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Extracurricular Activities")
            return cell
        } else {
            if (indexPath.section == 0) {
                if academicItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(recItem: academicItemArray[indexPath.row-1], count: academicItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Academic", count: academicItemArray.count)
                    return cell
                }
            } else if (indexPath.section == 1) {
                if researchItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(recItem: researchItemArray[indexPath.row-1], count: researchItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Research or Internship Project", count: researchItemArray.count)
                    return cell
                }
            } else {
                if activityItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(recItem: activityItemArray[indexPath.row-1], count: activityItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = myAchievementTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
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
            self.performSegue(withIdentifier:"gotoAchievementsRec", sender: self.myAchievementTableView.cellForRow(at: indexPath))
        })
        editAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the record\n\(self.editHSRec.title!)?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.deleteRecord(deleteActionForRowAt: indexPath)
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
    
    func deleteRecord(deleteActionForRowAt indexPath: IndexPath) {
        print("delete section \(indexPath.section) row = \(indexPath.row)")
        if (indexPath.section == 0) {
            academicItemArray.remove(at: indexPath.row-1)
            DispatchQueue.main.async {
                self.myAchievementTableView.reloadData() }
        } else if (indexPath.section == 1) {
            researchItemArray.remove(at: indexPath.row-1)
            DispatchQueue.main.async {
                self.myAchievementTableView.reloadData() }
        } else if (indexPath.section == 2) {
            activityItemArray.remove(at: indexPath.row-1)
            DispatchQueue.main.async {
                self.myAchievementTableView.reloadData() }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SchoolRecordDetailsController {
            let vc = segue.destination as? SchoolRecordDetailsController
            vc?.selectedSchoolYear = SchoolYearType.TENTH
            if sender != nil {
                vc?.editHSRec = self.editHSRec
            }
        }
    }
}

extension MyAchievementScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = myAchievementTableView.sizeThatFits(CGSize(width: size.width,
                                                            height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            myAchievementTableView?.beginUpdates()
            myAchievementTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = myAchievementTableView.indexPath(for: cell) {
                myAchievementTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
