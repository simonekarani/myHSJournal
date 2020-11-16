//
//  SchoolRecordDetailsController.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/7/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

class SchoolRecordDetailsController: UIViewController {
    
    @IBOutlet weak var recTitle: UITextField!
    
    @IBOutlet weak var recDetail: UITextView!
    
    @IBOutlet weak var recGrade: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recDetail.layer.cornerRadius = 5
        recDetail.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        recDetail.layer.borderWidth = 0.5
        recDetail.clipsToBounds = true
    }

    @IBAction func processRecAction(_ sender: Any) {
    }
}
