//
//  RecordsViewController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/1/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var recordsTableView: UITableView!
    
    let devCourses = [
        ("Before High School"), ("Freshmen Year"), ("Sophomore Year"),
        ("Junior Year"), ("Senior Year")
    ]
    let devCousesImages = [
        UIImage(named: "beforeHS"), UIImage(named: "grade9"), UIImage(named: "grade10"),
        UIImage(named: "grade11"), UIImage(named: "grade12"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        
        recordsTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "gotoBeforeHS", sender: self)
        case 1:
            performSegue(withIdentifier: "gotoFreshmen", sender: self)
        case 2:
            performSegue(withIdentifier: "gotoSophomore", sender: self)
        case 3:
            performSegue(withIdentifier: "gotoJunior", sender: self)
        case 4:
            performSegue(withIdentifier: "gotoSenior", sender: self)
        default:
            performSegue(withIdentifier: "gotoSenior", sender: self)
            
        }
    }
}

extension RecordsViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension RecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hsRecordCell", for: indexPath as IndexPath) as! RecordsTableViewCell
        
        cell.hsYearImg.image = self.devCousesImages[indexPath .row]
        cell.hsYear.text  = self.devCourses[indexPath .row]
        
        return cell
    }
}
