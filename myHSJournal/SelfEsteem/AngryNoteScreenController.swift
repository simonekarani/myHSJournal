//
//  AngryNoteScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/19/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class AngryNoteScreenController: UIViewController {
    
    @IBOutlet weak var angryTitle: UITextField!
    @IBOutlet weak var angryNote: UITextView!
    
    var editAngryRec: EsteemRecItem!
    var angryRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    var recCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        angryTitle.isUserInteractionEnabled = true
        angryNote.isEditable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            createRecord()
        }
        
        if (angryRecCount == 0 && recCreated == false) {
            let controllersInNavigationCount = self.navigationController?.viewControllers.count
        self.navigationController?.popToViewController(self.navigationController?.viewControllers[controllersInNavigationCount!-2] as! SelfEsteemScreenController, animated: true)
        }
    }
    
    func createRecord() {
        if (angryTitle.text == "" && angryNote.text == "") {
            return
        }
        
        recCreated = true
        let esteemRecItem = EsteemRecItem(context: self.context)
        esteemRecItem.esteemType = EsteemType.ANGRY.description
        esteemRecItem.feelingType = EsteemFeelingType.ANGRY.description
        esteemRecItem.timeMillis = getCurrentMillis()
        esteemRecItem.date = Date().string(format: "MM/dd/yyyy")
        esteemRecItem.msgTitle = angryTitle.text
        esteemRecItem.message = angryNote.text
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
