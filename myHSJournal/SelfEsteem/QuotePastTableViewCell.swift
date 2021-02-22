//
//  QuotePastTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/22/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class QuotePastTableViewCell: UITableViewCell {

    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var quoteMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recItem: QuoteRecItem) {
        quoteDate.text = recItem.quoteDate
        quoteMsg.text = recItem.quoteMsg! + "\n - " + recItem.quoteAuthor!
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
