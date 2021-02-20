//
//  AngryRecTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/19/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class AngryRecTableViewCell: UITableViewCell {

    @IBOutlet weak var angryTitle: UILabel!
    @IBOutlet weak var angryDate: UILabel!
    @IBOutlet weak var angryDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recItem: EsteemRecItem, count: Int) {
        angryTitle.text = recItem.msgTitle
        angryDate.text = recItem.date
        angryDetails.text = recItem.message
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
