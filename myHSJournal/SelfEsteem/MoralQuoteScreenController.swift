//
//  MoralQuoteScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/21/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import DropDown

class MoralQuoteScreenController: UIViewController {
    
    @IBOutlet weak var quoteDetail: UITextView!
    
    let mQuoteData: MoralQuoteData = MoralQuoteData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Past",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        
        let mQuote = mQuoteData.getMoralQuote()
        quoteDetail.text = "\"" + mQuote.quote! + "\"" + "\n\n\n" + "- " + mQuote.author!
        saveRecord(qMsg: mQuote.quote!, qAuthor: mQuote.author!)
        updateQuoteStoredList()
    }
    
    override func viewDidLayoutSubviews() {
        quoteDetail.centerVertically()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quoteDetail.centerVertically()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "gotoPastQuotes", sender: self)
    }
    
    func saveRecord(qMsg: String, qAuthor: String) {
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let quoteRecItem = QuoteRecItem(context: context)
            quoteRecItem.quoteDate = Date().string(format: "MM/dd/yyyy")
            quoteRecItem.quoteMsg = qMsg
            quoteRecItem.quoteAuthor = qAuthor
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let quoteRecItem = QuoteRecItem()
            quoteRecItem.quoteDate = Date().string(format: "MM/dd/yyyy")
            quoteRecItem.quoteMsg = qMsg
            quoteRecItem.quoteAuthor = qAuthor
        }
        saveContext()
    }
    
    func updateQuoteStoredList() {
        let request: NSFetchRequest<QuoteRecItem> = QuoteRecItem.fetchRequest()

        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let quoteItemArray = try context.fetch(request)
                if (quoteItemArray.count > 8) {
                    context.delete(quoteItemArray[0])
                    saveContext()
                }
            } catch {
                print("Error in loading \(error)")
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            do {
                let quoteItemArray = try context.fetch(request)
                if (quoteItemArray.count > 8) {
                    context.delete(quoteItemArray[0])
                    saveContext()
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
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
