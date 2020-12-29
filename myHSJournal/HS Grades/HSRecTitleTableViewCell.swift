//
//  HSRecTitleTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/25/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit

class HSRecTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String) {
        titleLabel.text = name
        setupCellDetails()
    }
    
    func setupCellDetails() {
        selectionStyle = .none
        
        backgroundColor = .lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
