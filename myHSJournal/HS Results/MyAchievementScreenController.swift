//
//  MyAchievementScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class MyAchievementScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "gotoAchievementsRec", sender: self)
    }
}
