//
//  SchoolRecordScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/4/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class SchoolRecordScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "gotoBeforeHsRec", sender: self)
    }
}
