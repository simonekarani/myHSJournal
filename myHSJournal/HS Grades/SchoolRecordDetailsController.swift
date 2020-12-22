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
    @IBOutlet weak var schoolYear: UITextField!

    @IBOutlet weak var titleLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBorderTextView(recView: recAward)
        addBorderTextView(recView: recDetail)
    }

    @IBAction func processRecAction(_ sender: Any) {
        let hsrecItem = HSRecItem(context: self.context)
        hsrecItem.recType = dropDown.selectedItem
        hsrecItem.schoolyear = schoolYear.text
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
    
    
    @IBAction func doCancelAction(_ sender: Any) {
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {
        dropDown.dataSource = [HSRecType.ACADEMIC.description, HSRecType.RESEARCH.description,
                               HSRecType.INTERNSHIP.description, HSRecType.PASSION.description,
                               HSRecType.EXTRACURRICULAR.description]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
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
