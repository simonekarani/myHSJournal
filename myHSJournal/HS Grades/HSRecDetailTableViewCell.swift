//
//  HSRecDetailTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/25/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit

class HSRecDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailDescription: UITextView!
    
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
            detailLabel.text = "No \(name) Records"
        } else {
            detailLabel.text = name
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
