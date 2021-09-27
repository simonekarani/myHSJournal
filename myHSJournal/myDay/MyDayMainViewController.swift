//
//  HygieneMainViewController.swift
//  happykids
//
//  Created by Simone Karani on 2/12/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class MyDayMainViewController: UIViewController {

    @IBOutlet weak var myDayTableView: UITableView!
    
    let devCourses = [
        ("How I did Today"), ("My Routine"),
        ("Good Deeds")
    ]
    let devCousesImages = [
        UIImage(named: "howDidIDo"), UIImage(named: "dayRoutine"),
        UIImage(named: "deeds")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.myDayTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.myDayTableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupTableView() {
        myDayTableView.delegate = self
        myDayTableView.dataSource = self
        
        myDayTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "gotoDidIDo", sender: self)
        case 1:
            performSegue(withIdentifier: "gotoRoutine", sender: self)
        case 2:
            performSegue(withIdentifier: "gotoDeeds", sender: self)
        default:
            performSegue(withIdentifier: "gotoDidIDo", sender: self)
            
        }
    }
}

extension MyDayMainViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

extension MyDayMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myDayCell", for: indexPath as IndexPath) as! MyDayMainTableViewCell
        
        cell.hygieneImg.image = self.devCousesImages[indexPath .row]
        cell.hygieneLabel.text  = self.devCourses[indexPath .row]
        
        return cell
    }
}
