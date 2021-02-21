//
//  FeelingNoteScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/20/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class FeelingNoteScreenController: UIViewController {
    
    @IBOutlet weak var feelingTypeButton: UIButton!
    @IBOutlet weak var feelingTitle: UITextField!
    @IBOutlet weak var feelingDetail: UITextView!
    
    var editFeelingRec: EsteemRecItem!
    var feelingRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    var recCreated = false
    
    let feelingDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        feelingDropDown.dataSource = [
            EsteemFeelingType.ANGRY.description, EsteemFeelingType.ANNOYED.description,
            EsteemFeelingType.BORED.description, EsteemFeelingType.EMBARRASSED.description,
            EsteemFeelingType.JEALOUS.description, EsteemFeelingType.HAPPY.description,
            EsteemFeelingType.SAD.description, EsteemFeelingType.SICK.description,
            EsteemFeelingType.STRESSED.description, EsteemFeelingType.SURPRISED.description,
            EsteemFeelingType.WORRIED.description
        ]

        if (editFeelingRec != nil) {
            feelingDropDown.selectRow(EsteemFeelingType.toInt(value: editFeelingRec.feelingType!))
            feelingTypeButton.setTitle(editFeelingRec.feelingType, for: .normal)
        } else {
            feelingDropDown.selectRow(6)
            feelingTypeButton.setTitle(EsteemFeelingType.HAPPY.description, for: .normal)
        }

        recCreated = false
        feelingTitle.isUserInteractionEnabled = true
        feelingDetail.isEditable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            createRecord()
        }
        
        if (feelingRecCount == 0 && recCreated == false) {
            let controllersInNavigationCount = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController(self.navigationController?.viewControllers[controllersInNavigationCount!-2] as! SelfEsteemScreenController, animated: true)
        }
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {
        feelingDropDown.anchorView = sender
        feelingDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        feelingDropDown.show()
        feelingDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
        }
    }
    
    func createRecord() {
        if (feelingTitle.text == "" && feelingDetail.text == "") {
            return
        }
        
        recCreated = true
        let esteemRecItem = EsteemRecItem(context: self.context)
        esteemRecItem.esteemType = EsteemType.FEELING.description
        esteemRecItem.feelingType = feelingDropDown.selectedItem
        esteemRecItem.timeMillis = getCurrentMillis()
        esteemRecItem.date = Date().string(format: "MM/dd/yyyy")
        esteemRecItem.msgTitle = feelingTitle.text
        esteemRecItem.message = feelingDetail.text
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}
