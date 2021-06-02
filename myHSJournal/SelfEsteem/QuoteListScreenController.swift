//
//  QuoteListScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/21/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class QuoteListScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var quoteTableViewList: UITableView!
        
    var quoteItemArray = [QuoteRecItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuoteRecords()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadQuoteRecords()
        DispatchQueue.main.async {
            self.quoteTableViewList.reloadData() }
    }
    
    func setupTableView() {
        quoteTableViewList.allowsSelection = false
        quoteTableViewList.allowsSelectionDuringEditing = false
        
        quoteTableViewList.delegate = self
        quoteTableViewList.dataSource = self
        
        // Set automatic dimensions for row height
        quoteTableViewList.rowHeight = UITableView.automaticDimension
        quoteTableViewList.estimatedRowHeight = UITableView.automaticDimension
        
        self.quoteTableViewList.register(UINib.init(nibName: "QuotePastTableViewCell", bundle: .main), forCellReuseIdentifier: "QuotePastTableViewCell")
        
        quoteTableViewList.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadQuoteRecords() {
        quoteItemArray.removeAll()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let request: NSFetchRequest<QuoteRecItem> = QuoteRecItem.fetchRequest()
            do {
                quoteItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuotePastTableViewCell = quoteTableViewList.dequeueReusableCell(withIdentifier: "QuotePastTableViewCell", for: indexPath) as! QuotePastTableViewCell
        var descendingIdx: Int = quoteItemArray.count - 1 - indexPath.row
        if (descendingIdx < 0) {
            descendingIdx = 0
        }
        cell.configureCell(recItem: quoteItemArray[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        return quoteItemArray.count
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> QuoteRecItem? {
        return quoteItemArray[indexPath.row]
    }
}

extension QuoteListScreenController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = quoteTableViewList.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            quoteTableViewList?.beginUpdates()
            quoteTableViewList?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = quoteTableViewList.indexPath(for: cell) {
                quoteTableViewList.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

