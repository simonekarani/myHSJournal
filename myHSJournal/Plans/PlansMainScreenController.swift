//
//  PlansMainScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class PlansMainScreenController: UIViewController {
    
    @IBOutlet weak var plansMainTableView: UITableView!
    
    let devCourses = [
        ("Goal Based Plans"), ("Yearly Plans"),
        ("Daily Todo")
    ]
    let devCousesImages = [
        UIImage(named: "goalPlan"), UIImage(named: "yearlyPlan"),
        UIImage(named: "dailyPlan")
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
        plansMainTableView.delegate = self
        plansMainTableView.dataSource = self
        
        plansMainTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "gotoGoalPlan", sender: self)
        case 1:
            performSegue(withIdentifier: "gotoYearlyPlan", sender: self)
        case 2:
            performSegue(withIdentifier: "gotoDailyPlan", sender: self)
        default:
            performSegue(withIdentifier: "gotoDailyPlan", sender: self)
            
        }
    }
}

extension PlansMainScreenController: UITableViewDelegate {
    
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

extension PlansMainScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plansMainCell", for: indexPath as IndexPath) as! PlansMainTableViewCell
        
        cell.plansImg.image = self.devCousesImages[indexPath .row]
        cell.plansTitle.text  = self.devCourses[indexPath .row]
        
        return cell
    }
}
