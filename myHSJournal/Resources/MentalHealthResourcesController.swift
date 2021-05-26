//
//  MentalHealthResourcesController.swift
//  myHSJournal
//
//  Created by Simone Karani on 3/7/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MentalHealthResourcesController: UIViewController {
    
    @IBOutlet weak var crisisTxtLine: UILabel!
    @IBOutlet weak var call911Label: UILabel!
    @IBOutlet weak var crisisMsgLabel: UILabel!
    @IBOutlet weak var crisis24Label: UILabel!
    @IBOutlet weak var crisisChatLabel: UILabel!
    @IBOutlet weak var resScrollView: UIScrollView!
    
    @IBOutlet weak var teensLabel: UILabel!
    @IBOutlet weak var natHealthLabel: UILabel!
    @IBOutlet weak var depressionLabel: UILabel!
    @IBOutlet weak var eatingLabel: UILabel!
    @IBOutlet weak var lgbtqTeensLabel: UILabel!
    @IBOutlet weak var violenceLabel: UILabel!    
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var readsLabel: UILabel!
    
    @IBOutlet weak var drugFreeLabel: UILabel!
    @IBOutlet weak var parentsDrugLabel: UILabel!
    @IBOutlet weak var drugCALabel: UILabel!
    @IBOutlet weak var drugHearingLabel: UILabel!
    
    @IBOutlet weak var ywcaLabel: UILabel!
    @IBOutlet weak var teensDatingLabel: UILabel!
    @IBOutlet weak var parentingSupportLabel: UILabel!
    @IBOutlet weak var nationalLgbtqLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teensLabel.isUserInteractionEnabled = true
        call911Label.isUserInteractionEnabled = true
        crisisMsgLabel.isUserInteractionEnabled = true
        crisis24Label.isUserInteractionEnabled = true
        crisisChatLabel.isUserInteractionEnabled = true
        
        teensLabel.isUserInteractionEnabled = true
        natHealthLabel.isUserInteractionEnabled = true
        depressionLabel.isUserInteractionEnabled = true
        eatingLabel.isUserInteractionEnabled = true
        lgbtqTeensLabel.isUserInteractionEnabled = true
        violenceLabel.isUserInteractionEnabled = true
        parentLabel.isUserInteractionEnabled = true
        readsLabel.isUserInteractionEnabled = true
        
        drugFreeLabel.isUserInteractionEnabled = true
        parentsDrugLabel.isUserInteractionEnabled = true
        drugCALabel.isUserInteractionEnabled = true
        drugHearingLabel.isUserInteractionEnabled = true
        
        ywcaLabel.isUserInteractionEnabled = true
        teensDatingLabel.isUserInteractionEnabled = true
        parentingSupportLabel.isUserInteractionEnabled = true
        nationalLgbtqLabel.isUserInteractionEnabled = true
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(teenLabelClicked(_:)))
        gesture1.numberOfTapsRequired = 1
        teensLabel.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(crisisTxtLabelClicked(_:)))
        gesture2.numberOfTapsRequired = 1
        crisisTxtLine.addGestureRecognizer(gesture2)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func teenLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.google.com"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc func crisisTxtLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.crisistextline.org"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
