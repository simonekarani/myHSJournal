//
//  ViewController.swift
//  myHSJournal
//
//  Created by Simone Karani on 10/25/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegue(withIdentifier: "gotoHSMainScreen", sender: self)
    }
    
}

