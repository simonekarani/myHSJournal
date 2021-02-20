//
//  LetterFriendScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/14/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class LetterFriendScreenController: UIViewController {
    
    @IBOutlet weak var friendName: UITextField!
    
    @IBOutlet weak var friendLetter: UITextView!
    
    var editLetterRec: EsteemRecItem!
    var letterRecCount: Int!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recItemArray = [String]()
    var recCreated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        friendName.isUserInteractionEnabled = true
        friendLetter.isEditable = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            createRecord()
        }
        if (letterRecCount == 0 && recCreated == false) {
            let controllersInNavigationCount = self.navigationController?.viewControllers.count
        self.navigationController?.popToViewController(self.navigationController?.viewControllers[controllersInNavigationCount!-2] as! SelfEsteemScreenController, animated: true)
        }
    }

    func createRecord() {
        if friendName.text == "" && friendLetter.text == "" {
            return
        }
        
        recCreated = true
        let esteemRecItem = EsteemRecItem(context: self.context)
        esteemRecItem.esteemType = EsteemType.LETTER.description
        esteemRecItem.feelingType = EsteemFeelingType.HAPPY.description
        esteemRecItem.timeMillis = getCurrentMillis()
        esteemRecItem.date = Date().string(format: "MM/dd/yyyy")
        esteemRecItem.msgTitle = friendName.text
        esteemRecItem.message = friendLetter.text
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

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
