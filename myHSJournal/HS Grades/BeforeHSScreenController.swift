//
//  BeforeHSScreenController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/2/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class BeforeHSScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
    }
    
    @objc private func addTapped() {
        performSegue(withIdentifier: "gotoBeforeHsRec", sender: self)
    }
}
