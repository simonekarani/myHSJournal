//
//  PastMyDayTableViewCell.swift
//  happykids
//
//  Created by Simone Karani on 7/15/21.
//

import UIKit

class PastMyDayTableViewCell: UITableViewCell {

    @IBOutlet weak var pastDateLbl: UILabel!
    @IBOutlet weak var pastHowDayImg: UIImageView!
    @IBOutlet weak var pastHowDayLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recItem: MyDayRecItem) {
        let dStr: String = Date().getFormattedDate(format: "MM/dd/yyyy")
        if dStr == recItem.dayDate! {
            pastDateLbl.text = "Today - " + recItem.dayDate!
        } else {
            pastDateLbl.text = recItem.dayDate!
        }
        pastHowDayLbl.text = recItem.howStatus!
        switch recItem.howStatus! {
        case "Hooray":
                pastHowDayImg.image = UIImage(named: "hooray")
        case "Yay":
            pastHowDayImg.image = UIImage(named: "yay")
        case "Meh":
                pastHowDayImg.image = UIImage(named: "meh")
        case "Oops":
            pastHowDayImg.image = UIImage(named: "oops")
        case "Yikes":
            pastHowDayImg.image = UIImage(named: "yikes")

        default:
            pastHowDayImg.image = UIImage(named: "hooray")
        }
        
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
