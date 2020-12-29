//
//  HSRecNoValueTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/28/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit

class HSRecNoValueTableViewCell: UITableViewCell {

    @IBOutlet weak var noValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String, count: Int) {
        if (count == 0) {
            noValueLabel.text = "No \(name) Records"
        } else {
            noValueLabel.text = name
        }
        setupCellDetails()
    }

    func setupCellDetails() {
        selectionStyle = .none
        
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
