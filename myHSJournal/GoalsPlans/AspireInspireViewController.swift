//
//  AspireInspireViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/14/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AspireInspireViewController: UIViewController {
    
    @IBOutlet weak var inspireName: UITextField!
    
    @IBOutlet weak var inspireReasons: UITextView!
    
    var editAspireRec: AspireRecItem!
    var aspireRecCount: Int!

    var recItemArray = [String]()
    var recCreated = false
    var recState: HSRecState = .NONE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recCreated = false
        inspireName.isUserInteractionEnabled = true
        inspireReasons.isEditable = true

        if (editAspireRec != nil) {
            inspireName.text = editAspireRec.aspireTo!
            inspireReasons.text = editAspireRec.aspireReasons!
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
        if (aspireRecCount == 0 && recCreated == false) {
            let controllersInNavigationCount = self.navigationController?.viewControllers.count
        self.navigationController?.popToViewController(self.navigationController?.viewControllers[controllersInNavigationCount!-2] as! PlansMainScreenController, animated: true)
        }
    }

    func createRecord() {
        if inspireName.text == "" && inspireReasons.text == "" {
            return
        }
        
        recCreated = true
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let esteemRecItem = AspireRecItem(context: context)
            esteemRecItem.timeMillis = getCurrentMillis()
            esteemRecItem.date = Date().getFormattedDate(format: "MM/dd/yyyy")
            esteemRecItem.aspireTo = inspireName.text
            esteemRecItem.aspireReasons = inspireReasons.text
        } else {
            // Fallback on earlier versions
            let esteemRecItem = AspireRecItem()
            esteemRecItem.timeMillis = getCurrentMillis()
            esteemRecItem.date = Date().getFormattedDate(format: "MM/dd/yyyy")
            esteemRecItem.aspireTo = inspireName.text
            esteemRecItem.aspireReasons = inspireReasons.text
        }
        saveContext()
    }
    
    func updateRecord() {
        var esteemItemArray = [AspireRecItem]()
        let request: NSFetchRequest<AspireRecItem> = AspireRecItem.fetchRequest()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                esteemItemArray = try context.fetch(request)
                var isFound: Bool = false
                for (_, element) in esteemItemArray.enumerated() {
                    if (element.timeMillis == editAspireRec.timeMillis) {
                        element.aspireTo = inspireName.text
                        element.aspireReasons = inspireReasons.text
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
                    if (element.timeMillis == editAspireRec.timeMillis) {
                        element.aspireTo = inspireName.text
                        element.aspireReasons = inspireReasons.text
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
