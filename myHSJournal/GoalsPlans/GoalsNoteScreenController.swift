//
//  GoalsNoteScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/27/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GoalsNoteScreenController: UIViewController {
    
    @IBOutlet weak var goalsTitle: UITextField!
    @IBOutlet weak var goalsDetails: UITextView!
    
    var editGoalsRec: GoalsRecItem!
    var goalsRecCount: Int!
    
    var recItemArray = [String]()
    var recCreated = false
    var recState: HSRecState = .NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        goalsTitle.isUserInteractionEnabled = true
        goalsDetails.isEditable = true
        
        if (editGoalsRec != nil) {
            goalsTitle.text = editGoalsRec.title!
            goalsDetails.text = editGoalsRec.goalDetails!
            recState = .UPDATE
        } else {
            recState = .ADD
        }
        
        addBorderTextView(recView: goalsDetails)
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
        if (goalsRecCount == 0 && recCreated == false) {
            let controllersInNavigationCount = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController(self.navigationController?.viewControllers[controllersInNavigationCount!-2] as! PlansMainScreenController, animated: true)
        }
    }
    
    func createRecord() {
        if goalsTitle.text == "" {
            return
        }
        
        recCreated = true
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let goalsRecItem = GoalsRecItem(context: context)
            goalsRecItem.timeMillis = getCurrentMillis()
            goalsRecItem.dateSet = Date().string(format: "MM/dd/yyyy")
            goalsRecItem.title = goalsTitle.text
            goalsRecItem.goalDetails = goalsDetails.text
            goalsRecItem.completed = false
            saveContext()
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

            let goalsRecItem = GoalsRecItem()
            goalsRecItem.timeMillis = getCurrentMillis()
            goalsRecItem.dateSet = Date().string(format: "MM/dd/yyyy")
            goalsRecItem.title = goalsTitle.text
            goalsRecItem.goalDetails = goalsDetails.text
            goalsRecItem.completed = false
            saveContext()
        }
    }
    
    func updateRecord() {
        var goalsItemArray = [GoalsRecItem]()
        let request: NSFetchRequest<GoalsRecItem> = GoalsRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            do {
                goalsItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in goalsItemArray.enumerated() {
                    if (element.timeMillis == editGoalsRec.timeMillis) {
                        element.title = goalsTitle.text
                        element.goalDetails = goalsDetails.text
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
                goalsItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in goalsItemArray.enumerated() {
                    if (element.timeMillis == editGoalsRec.timeMillis) {
                        element.title = goalsTitle.text
                        element.goalDetails = goalsDetails.text
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
    
    func addBorderTextView(recView: UITextView) {
        recView.layer.cornerRadius = 5
        recView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        recView.layer.borderWidth = 0.5
        recView.clipsToBounds = true
    }

    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
