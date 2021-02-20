//
//  SelfEsteemScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/12/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import UIKit

class SelfEsteemScreenController: UIViewController {

    @IBOutlet weak var esteemTableView: UITableView!
    
    let devCourses = [
        ("Today's Self-Booster"), ("Feeling Today?"),
        ("What Made Me Angry?"), ("Note To Friend"),
        ("Anxiety Report!")
    ]
    let devCousesImages = [
        UIImage(named: "booster"), UIImage(named: "feeling"),
        UIImage(named: "angry"), UIImage(named: "friends"),
        UIImage(named: "stressreport"),
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
        esteemTableView.delegate = self
        esteemTableView.dataSource = self
        
        esteemTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "gotoBooster", sender: self)
        case 1:
            performSegue(withIdentifier: "gotoFeltGood", sender: self)
        case 2:
            performSegue(withIdentifier: "gotoAngryList", sender: self)
        case 3:
            performSegue(withIdentifier: "gotoFriendList", sender: self)
        case 4:
            performSegue(withIdentifier: "gotoStressReport", sender: self)
        default:
            performSegue(withIdentifier: "gotoBooster", sender: self)
            
        }
    }
}

extension SelfEsteemScreenController: UITableViewDelegate {
    
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

extension SelfEsteemScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "esteemCell", for: indexPath as IndexPath) as! EsteemMainTableViewCell
        
        cell.esteemImg.image = self.devCousesImages[indexPath .row]
        cell.esteemLabel.text  = self.devCourses[indexPath .row]
        
        return cell
    }
}
