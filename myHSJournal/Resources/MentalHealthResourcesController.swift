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
        
        call911Label.isUserInteractionEnabled = true
        crisisTxtLine.isUserInteractionEnabled = true
        crisisMsgLabel.isUserInteractionEnabled = true
        crisis24Label.isUserInteractionEnabled = true
        
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
        
        setupLabelInteractions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupLabelInteractions() {
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(call911LabelClicked(_:)))
        gesture1.numberOfTapsRequired = 1
        call911Label.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(crisisTxtLabelClicked(_:)))
        gesture2.numberOfTapsRequired = 1
        crisisTxtLine.addGestureRecognizer(gesture2)

        let gesture18 = UITapGestureRecognizer(target: self, action: #selector(call24LabelClicked(_:)))
        gesture18.numberOfTapsRequired = 1
        crisis24Label.addGestureRecognizer(gesture18)
        
        let gesture19 = UITapGestureRecognizer(target: self, action: #selector(crisisMsgLabelClicked(_:)))
        gesture19.numberOfTapsRequired = 1
        crisisMsgLabel.addGestureRecognizer(gesture19)
        
        // ----
        let gesture6 = UITapGestureRecognizer(target: self, action: #selector(nathealthLabelClicked(_:)))
        gesture6.numberOfTapsRequired = 1
        natHealthLabel.addGestureRecognizer(gesture6)
        
        let gesture5 = UITapGestureRecognizer(target: self, action: #selector(depressionLabelClicked(_:)))
        gesture5.numberOfTapsRequired = 1
        depressionLabel.addGestureRecognizer(gesture5)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(eatingLabelClicked(_:)))
        gesture4.numberOfTapsRequired = 1
        eatingLabel.addGestureRecognizer(gesture4)

        let gesture15 = UITapGestureRecognizer(target: self, action: #selector(lgbtqteensLabelClicked(_:)))
        gesture15.numberOfTapsRequired = 1
        lgbtqTeensLabel.addGestureRecognizer(gesture15)
        
        let gesture16 = UITapGestureRecognizer(target: self, action: #selector(dviolenceLabelClicked(_:)))
        gesture16.numberOfTapsRequired = 1
        violenceLabel.addGestureRecognizer(gesture16)
        
        let gesture17 = UITapGestureRecognizer(target: self, action: #selector(natparentLabelClicked(_:)))
        gesture17.numberOfTapsRequired = 1
        parentLabel.addGestureRecognizer(gesture17)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(readsLabelClicked(_:)))
        gesture3.numberOfTapsRequired = 1
        readsLabel.addGestureRecognizer(gesture3)

        // ----
        let gesture7 = UITapGestureRecognizer(target: self, action: #selector(drugfreeLabelClicked(_:)))
        gesture7.numberOfTapsRequired = 1
        drugFreeLabel.addGestureRecognizer(gesture7)

        let gesture8 = UITapGestureRecognizer(target: self, action: #selector(parentsDrugLabelClicked(_:)))
        gesture8.numberOfTapsRequired = 1
        parentsDrugLabel.addGestureRecognizer(gesture8)

        let gesture13 = UITapGestureRecognizer(target: self, action: #selector(drugcaLabelClicked(_:)))
        gesture13.numberOfTapsRequired = 1
        drugCALabel.addGestureRecognizer(gesture13)
        
        let gesture14 = UITapGestureRecognizer(target: self, action: #selector(drughearingLabelClicked(_:)))
        gesture14.numberOfTapsRequired = 1
        drugHearingLabel.addGestureRecognizer(gesture14)
        
        // ----
        let gesture9 = UITapGestureRecognizer(target: self, action: #selector(ywcaLabelClicked(_:)))
        gesture9.numberOfTapsRequired = 1
        ywcaLabel.addGestureRecognizer(gesture9)

        let gesture10 = UITapGestureRecognizer(target: self, action: #selector(teensLabelClicked(_:)))
        gesture10.numberOfTapsRequired = 1
        teensDatingLabel.addGestureRecognizer(gesture10)

        let gesture11 = UITapGestureRecognizer(target: self, action: #selector(parentingLabelClicked(_:)))
        gesture11.numberOfTapsRequired = 1
        parentingSupportLabel.addGestureRecognizer(gesture11)

        let gesture12 = UITapGestureRecognizer(target: self, action: #selector(lgbtqLabelClicked(_:)))
        gesture12.numberOfTapsRequired = 1
        nationalLgbtqLabel.addGestureRecognizer(gesture12)
    }
    
    @objc func call911LabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://911"),
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

    @objc func call24LabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18002738255"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func crisisMsgLabelClicked(_ sender: Any) {
        guard let url = URL(string: "sms://741741"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // ---
    @objc func nathealthLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.nimh.nih.gov"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func depressionLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.adaa.org"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func eatingLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.nationaleatingdisorders.org"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func lgbtqteensLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18002467743"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func natparentLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18554272736"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func dviolenceLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18007997233"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
   @objc func readsLabelClicked(_ sender: Any) {
        guard let url = URL(string: "https://www.amazon.com/Prescriptions-Without-Pills-Depression-Anxiety/dp/1630478105/ref=sr_1_5?dchild=1&keywords=prescriptions+without+pills&qid=1620984361&sr=8-5"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // ---
    @objc func drugfreeLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.drugfree.org"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func parentsDrugLabelClicked(_ sender: Any) {
        guard let url = URL(string: "http://www.FlavorsHookKids.org"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func drugcaLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18006628887"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func drughearingLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18009334833"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // ---
    @objc func ywcaLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18005722782"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func teensLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18663319474"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func parentingLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18882207575"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc func lgbtqLabelClicked(_ sender: Any) {
        guard let url = URL(string: "tel://18002467743"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
