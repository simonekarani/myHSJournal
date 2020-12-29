//
//  JuniorScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class JuniorScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        loadHSRecords()
    }

    @objc private func addTapped() {
        performSegue(withIdentifier: "gotoJuniorRec", sender: self)
    }
    
    func loadHSRecords() {
        
    }
}
