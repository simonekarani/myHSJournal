//
//  SchoolRecordDetailsController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/7/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import CoreData
import Foundation
import UIKit
import DropDown

class SchoolRecordDetailsController: UIViewController {
    
    @IBOutlet weak var recType: UIButton!
    
    @IBOutlet weak var recTitle: UITextField!
    @IBOutlet weak var recDetail: UITextView!
    @IBOutlet weak var recGrade: UITextField!
    @IBOutlet weak var recAward: UITextView!
    @IBOutlet weak var schoolYear: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var editHSRec: HSRecItem!
    var selectedSchoolYear: SchoolYearType!
    
    var recItemArray = [String]()
    var recState: HSRecState = .NONE
    
    let dropDown = DropDown()
    let yearDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown.dataSource = [HSRecType.ACADEMIC.description, HSRecType.RESEARCH.description,
                               HSRecType.INTERNSHIP.description, HSRecType.PASSION.description,
                               HSRecType.EXTRACURRICULAR.description]
        yearDropDown.dataSource = [SchoolYearType.SIXTH.description, SchoolYearType.SEVENTH.description,
                                   SchoolYearType.EIGHTH.description, SchoolYearType.NINETH.description,
                                   SchoolYearType.TENTH.description, SchoolYearType.ELEVENTH.description,
                                   SchoolYearType.TWELVETH.description]

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(popToPrevious)
        )

        if (selectedSchoolYear != nil) {
            yearDropDown.selectRow(selectedSchoolYear.asInt())
            schoolYear.setTitle(selectedSchoolYear.description, for: .normal)
            dropDown.selectRow(0)
            recType.setTitle(HSRecType.ACADEMIC.description, for: .normal)
            recState = .ADD
        } else {
            yearDropDown.selectRow(1)
            schoolYear.setTitle(SchoolYearType.SEVENTH.description, for: .normal)
            dropDown.selectRow(0)
            recType.setTitle(HSRecType.ACADEMIC.description, for: .normal)
            recState = .ADD
        }
        
        if (editHSRec != nil) {
            recTitle.text = editHSRec.title!
            recGrade.text = editHSRec.grade!
            recAward.text = editHSRec.recognition!
            recDetail.text = editHSRec.desc!
            dropDown.selectRow(HSRecType.toInt(value: editHSRec.recType!))
            recType.setTitle(editHSRec.recType!, for: .normal)
            yearDropDown.selectRow(SchoolYearType.toInt(value: editHSRec.schoolyear!))
            schoolYear.setTitle(editHSRec.schoolyear!, for: .normal)
            recState = .UPDATE
        }

        addBorderTextView(recView: recAward)
        addBorderTextView(recView: recDetail)
    }

    @objc private func saveTapped() {
        let rectitle: String = recTitle.text!
        let schoolyear: String = yearDropDown.selectedItem!
        if recState == .ADD {
            if !isRecordExists(rectitle: rectitle, schoolYear: schoolyear) {
                createRecord()
                navigationController?.popViewController(animated: true)
            } else {
                alertMessage(title: rectitle)
            }
        } else {
            updateRecord(rectitle: rectitle)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func isRecordExists(rectitle: String, schoolYear: String) -> Bool {
        var hsItemArray = [HSRecItem]()
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                hsItemArray = try context.fetch(request)
                for (_, element) in hsItemArray.enumerated() {
                    if element.title == rectitle {
                        return true
                    }
                }
            } catch {
                print("Error in loading \(error)")
            }
        }
        return false
    }
    
    func createRecord() {
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let hsrecItem = HSRecItem(context: context)
            hsrecItem.recType = dropDown.selectedItem
            hsrecItem.schoolyear = yearDropDown.selectedItem
            hsrecItem.title = recTitle.text!
            hsrecItem.grade = recGrade.text
            hsrecItem.recognition = recAward.text
            hsrecItem.desc = recDetail.text
            saveContext()
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let hsrecItem = HSRecItem()
            hsrecItem.recType = dropDown.selectedItem
            hsrecItem.schoolyear = yearDropDown.selectedItem
            hsrecItem.title = recTitle.text!
            hsrecItem.grade = recGrade.text
            hsrecItem.recognition = recAward.text
            hsrecItem.desc = recDetail.text
            saveContext()
        }
    }
    
    func updateRecord(rectitle: String) {
        var hsItemArray = [HSRecItem]()
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                hsItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in hsItemArray.enumerated() {
                    if (element.title == rectitle) {
                        element.recType = dropDown.selectedItem
                        element.schoolyear = yearDropDown.selectedItem
                        element.title = recTitle.text!
                        element.grade = recGrade.text
                        element.recognition = recAward.text
                        element.desc = recDetail.text
                        saveContext()
                        isFound = true
                        return
                    }
                }
                if !isFound {
                   createRecord()
                }
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                hsItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in hsItemArray.enumerated() {
                    if (element.title == rectitle) {
                        element.recType = dropDown.selectedItem
                        element.schoolyear = yearDropDown.selectedItem
                        element.title = recTitle.text!
                        element.grade = recGrade.text
                        element.recognition = recAward.text
                        element.desc = recDetail.text
                        saveContext()
                        isFound = true
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
    }

    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) 
        }
    }
    
    @IBAction func schoolYearDropDownAction(_ sender: UIButton) {
        yearDropDown.anchorView = sender
        yearDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        yearDropDown.show()
        yearDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
        }
    }
    
    func addBorderTextView(recView: UITextView) {
        recView.layer.cornerRadius = 5
        recView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        recView.layer.borderWidth = 0.5
        recView.clipsToBounds = true
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
    
    func alertMessage(title: String) {
        let alert = UIAlertController(title: "Add High School Record?",
                                      message: "Record with title \(title) exists?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
