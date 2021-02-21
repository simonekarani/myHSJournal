//
//  AngryNoteScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/19/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AngryNoteScreenController: UIViewController {
    
    @IBOutlet weak var angryTitle: UITextField!
    @IBOutlet weak var angryNote: UITextView!
    
    var editEsteemRec: EsteemRecItem!
    var esteemRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    var recCreated = false
    var recState:HSRecState = .NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        angryTitle.isUserInteractionEnabled = true
        angryNote.isEditable = true

        if (editEsteemRec != nil) {
            angryTitle.text = editEsteemRec.msgTitle!
            angryNote.text = editEsteemRec.message!
            recState = .UPDATE
        } else {
            recState = .ADD
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            if (recState == .ADD) {
                createRecord()
            } else {
                updateRecord()
            }
        }
        
        if (esteemRecCount == 0 && recCreated == false) {
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
    
    func updateRecord() {
        var esteemItemArray = [EsteemRecItem]()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        do {
            esteemItemArray = try context.fetch(request)
            var isFound: Bool = false
            for (_, element) in esteemItemArray.enumerated() {
                if (element.timeMillis == editEsteemRec.timeMillis) {
                    element.msgTitle = angryTitle.text
                    element.message = angryNote.text
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
