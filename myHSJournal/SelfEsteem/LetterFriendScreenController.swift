//
//  LetterFriendScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/14/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LetterFriendScreenController: UIViewController {
    
    @IBOutlet weak var friendName: UITextField!
    
    @IBOutlet weak var friendLetter: UITextView!
    
    var editEsteemRec: EsteemRecItem!
    var esteemRecCount: Int!

    var recItemArray = [String]()
    var recCreated = false
    var recState: HSRecState = .NONE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        friendName.isUserInteractionEnabled = true
        friendLetter.isEditable = true

        if (editEsteemRec != nil) {
            friendName.text = editEsteemRec.msgTitle!
            friendLetter.text = editEsteemRec.message!
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
        if friendName.text == "" && friendLetter.text == "" {
            return
        }
        
        recCreated = true
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let esteemRecItem = EsteemRecItem(context: context)
            esteemRecItem.esteemType = EsteemType.LETTER.description
            esteemRecItem.feelingType = EsteemFeelingType.HAPPY.description
            esteemRecItem.timeMillis = getCurrentMillis()
            esteemRecItem.date = Date().string(format: "MM/dd/yyyy")
            esteemRecItem.msgTitle = friendName.text
            esteemRecItem.message = friendLetter.text
            saveContext()
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let esteemRecItem = EsteemRecItem()
            esteemRecItem.esteemType = EsteemType.LETTER.description
            esteemRecItem.feelingType = EsteemFeelingType.HAPPY.description
            esteemRecItem.timeMillis = getCurrentMillis()
            esteemRecItem.date = Date().string(format: "MM/dd/yyyy")
            esteemRecItem.msgTitle = friendName.text
            esteemRecItem.message = friendLetter.text
            saveContext()
        }
    }
    
    func updateRecord() {
        var esteemItemArray = [EsteemRecItem]()
        let request: NSFetchRequest<EsteemRecItem> = EsteemRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                esteemItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in esteemItemArray.enumerated() {
                    if (element.timeMillis == editEsteemRec.timeMillis) {
                        element.msgTitle = friendName.text
                        element.message = friendLetter.text
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
                esteemItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in esteemItemArray.enumerated() {
                    if (element.timeMillis == editEsteemRec.timeMillis) {
                        element.msgTitle = friendName.text
                        element.message = friendLetter.text
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

    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
