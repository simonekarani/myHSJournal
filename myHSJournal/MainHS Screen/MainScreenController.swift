//
//  MainScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/1/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class MainScreenController: UICollectionViewController {
    
    let frontLabelArray = ["Pre High School", "Freshmen Year", "Sophomore Year", "Junior Year", "Senior Year", "My Achievements"]
    let frontImageArray = [
        UIImage(named: "beforeHS"),
        UIImage(named: "grade9"),
        UIImage(named: "grade10"),
        UIImage(named: "grade11"),
        UIImage(named: "grade12"),
        UIImage(named: "report")
    ]
    var tablefontSize: Int = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize( width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/4)
        
        //        self.navigationController?.navigationBar.titleTextAttributes =
        //            [NSAttributedString.Key.foregroundColor: UIColor.red,
        //             NSAttributedString.Key.font: UIFont(name: "Verdana", size: 22)!]
        
        print("frame=\(self.view.frame) , width=\(self.view.frame.width), height=\(self.view.frame.height)")
        
        self.navigationItem.setHidesBackButton(true,  animated:true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frontImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frontCell", for: indexPath) as! MainScreenCollectionCell
        
        cell.frontLabel.text = frontLabelArray[indexPath.item]
        cell.frontImage.image = frontImageArray[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //UserDefaults.standard.set(0, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoBeforeHS", sender: self)
            
        case 1:
            //UserDefaults.standard.set(1, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoFreshmen", sender: self)
            
        case 2:
            //UserDefaults.standard.set(2, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoSophomore", sender: self)

        case 3:
            //UserDefaults.standard.set(3, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoJunior", sender: self)
            
        case 4:
            //UserDefaults.standard.set(4, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoSenior", sender: self)
           
        case 5:
            //UserDefaults.standard.set(5, forKey: "UserSelection")
            performSegue(withIdentifier: "gotoAchievements", sender: self)
            
        default:
            performSegue(withIdentifier: "gotoAchievements", sender: self)
        }
    }
    
    
    @IBAction func backFromUnwind(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}
