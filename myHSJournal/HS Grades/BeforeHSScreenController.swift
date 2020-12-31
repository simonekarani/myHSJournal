//
//  BeforeHSScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class BeforeHSScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var beforeHSTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hsItemArray = [HSRecItem]()
    var academicItemArray = [HSRecItem]()
    var researchItemArray = [HSRecItem]()
    var activityItemArray = [HSRecItem]()
    var academicRecCount: Int = 0
    var researchRecCount: Int = 0
    var activityRecCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHSRecords()
        
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func setupTableView() {
        beforeHSTableView.delegate = self
        beforeHSTableView.dataSource = self
        
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecTitleTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecTitleTableViewCell")
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecDetailTableViewCell")
        self.beforeHSTableView.register(UINib.init(nibName: "HSRecNoValueTableViewCell", bundle: .main), forCellReuseIdentifier: "HSRecNoValueTableViewCell")
        
        beforeHSTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @objc private func addTapped() {
        performSegue(withIdentifier: "gotoBeforeHsRec", sender: self)
    }

    func loadHSRecords() {
        let request: NSFetchRequest<HSRecItem> = HSRecItem.fetchRequest()
        do {
            hsItemArray = try context.fetch(request)
            for (index, element) in hsItemArray.enumerated() {
                print(index, ":", element)
                if (element.recType == "Academic") {
                    academicItemArray.append(element)
                } else if (element.recType == "Extracurricular") {
                    activityItemArray.append(element)
                } else {
                    researchItemArray.append(element)
                }
            }
        } catch {
            print("Error in loading \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getRecordCount()
        if (section == 0) {
            return academicRecCount
        } else if (section == 1) {
            return researchRecCount
        } else {
            return activityRecCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("** row = \(indexPath.row) section = \(indexPath.section) count=\(indexPath.count)")
        if (indexPath.section == 0 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Academic")
            return cell
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Research / Internship / Passion Project")
            return cell
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            let cell: HSRecTitleTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecTitleTableViewCell", for: indexPath) as! HSRecTitleTableViewCell
            cell.configureCell(name: "Extracurricular Activities")
            return cell
        } else {
            if (indexPath.section == 0) {
                if academicItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(name: academicItemArray[indexPath.row-1].title!, grade: academicItemArray[indexPath.row-1].grade!, count: academicItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Academic", count: academicItemArray.count)
                    return cell
                }
            } else if (indexPath.section == 1) {
                if researchItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(name: researchItemArray[indexPath.row-1].title!, grade: researchItemArray[indexPath.row-1].grade!, count: researchItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Research or Internship Project", count: researchItemArray.count)
                    return cell
                }
            } else {
                if activityItemArray.count > 0 {
                    let cell: HSRecDetailTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecDetailTableViewCell", for: indexPath) as! HSRecDetailTableViewCell
                    cell.configureCell(name: activityItemArray[indexPath.row-1].title!, grade: activityItemArray[indexPath.row-1].grade!, count: activityItemArray.count)
                    return cell
                } else {
                    let cell: HSRecNoValueTableViewCell = beforeHSTableView.dequeueReusableCell(withIdentifier: "HSRecNoValueTableViewCell", for: indexPath) as! HSRecNoValueTableViewCell
                    cell.configureCell(name: "Extracurricular Activities", count: activityItemArray.count)
                    return cell
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func getRecordCount() {
        // add 1 for each section heading
        academicRecCount = academicItemArray.count + 1
        if academicItemArray.count == 0 {
            academicRecCount += 1
        }
        researchRecCount = researchItemArray.count + 1
        if researchItemArray.count == 0 {
            researchRecCount += 1
        }
        activityRecCount = activityItemArray.count + 1
        if activityItemArray.count == 0 {
            activityRecCount += 1
        }
    }
}
