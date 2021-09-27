//
//  PastDayViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/21/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import Foundation
import UIKit

class PastDayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myDayTableView: UITableView!
    @IBOutlet weak var mehLabel: UILabel!
    @IBOutlet weak var yayLabel: UILabel!
    @IBOutlet weak var oopsLabel: UILabel!
    @IBOutlet weak var hoorayLabel: UILabel!
    @IBOutlet weak var yikesLabel: UILabel!
    
    var myDayItemArray = [MyDayRecItem]()
    var hoorayCount: Int = 0
    var yayCount: Int = 0
    var mehCount: Int = 0
    var oopsCount: Int = 0
    var yikesCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMyDayRecords()
        setupTableView()
        
        hoorayLabel.text = "\(hoorayCount)"
        yayLabel.text = "\(yayCount)"
        mehLabel.text = "\(mehCount)"
        oopsLabel.text = "\(oopsCount)"
        yikesLabel.text = "\(yikesCount)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyDayRecords()
        DispatchQueue.main.async {
            self.myDayTableView.reloadData() }
    }
    
    func setupTableView() {
        myDayTableView.allowsSelection = false
        myDayTableView.allowsSelectionDuringEditing = false
        
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        
        // Set automatic dimensions for row height
        myDayTableView.rowHeight = UITableView.automaticDimension
        myDayTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.myDayTableView.register(UINib.init(nibName: "PastMyDayTableViewCell", bundle: .main), forCellReuseIdentifier: "pastMyDayTableViewCell")
        
        myDayTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func loadMyDayRecords() {
        myDayItemArray.removeAll()
        if #available(iOS 10.0, *) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let request: NSFetchRequest<MyDayRecItem> = MyDayRecItem.fetchRequest()
            do {
                myDayItemArray = try context.fetch(request)
            } catch {
                print("Error in loading \(error)")
            }
        }
        
        for mydayRec in myDayItemArray {
            switch mydayRec.howStatus! {
            case "Hooray":
                hoorayCount += 1
            case "Yay":
                yayCount += 1
            case "Meh":
                mehCount += 1
            case "Oops":
                oopsCount += 1
            case "Yikes":
                yikesCount += 1

            default:
                hoorayCount += 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRecordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PastMyDayTableViewCell = myDayTableView.dequeueReusableCell(withIdentifier: "pastMyDayTableViewCell", for: indexPath) as! PastMyDayTableViewCell
        var descendingIdx: Int = myDayItemArray.count - 1 - indexPath.row
        if (descendingIdx < 0) {
            descendingIdx = 0
        }
        cell.configureCell(recItem: myDayItemArray[descendingIdx])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() -> Int {
        return myDayItemArray.count
    }
    
    func getRecord(actionForRowAt indexPath: IndexPath) -> MyDayRecItem? {
        return myDayItemArray[indexPath.row]
    }
}

extension PastDayViewController: GrowingCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = myDayTableView.sizeThatFits(CGSize(width: size.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            myDayTableView?.beginUpdates()
            myDayTableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = myDayTableView.indexPath(for: cell) {
                myDayTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

