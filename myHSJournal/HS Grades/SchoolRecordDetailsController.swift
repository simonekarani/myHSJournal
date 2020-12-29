//
//  SchoolRecordDetailsController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/7/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    
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

        yearDropDown.selectRow(1)
        schoolYear.setTitle(SchoolYearType.SEVENTH.description, for: .normal)

        addBorderTextView(recView: recAward)
        addBorderTextView(recView: recDetail)
    }

    @objc private func saveTapped() {
        let hsrecItem = HSRecItem(context: self.context)
        hsrecItem.recType = dropDown.selectedItem
        hsrecItem.schoolyear = yearDropDown.selectedItem
        hsrecItem.title = recTitle.text!
        hsrecItem.grade = recGrade.text
        hsrecItem.recognition = recAward.text
        hsrecItem.desc = recDetail.text
        print(hsrecItem)
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
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
}
