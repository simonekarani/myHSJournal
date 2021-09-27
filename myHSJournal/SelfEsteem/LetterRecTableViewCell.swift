//
//  LetterRecTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/16/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class LetterRecTableViewCell: UITableViewCell {

    @IBOutlet weak var titleMsg: UILabel!
    
    @IBOutlet weak var dateMsg: UILabel!
    
    @IBOutlet weak var detailMsg: UILabel!
    
    weak var cellDelegate: LetterTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailMsg.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(recItem: EsteemRecItem, count: Int) {
        titleMsg.text = recItem.msgTitle
        dateMsg.text = recItem.date
        detailMsg.text = recItem.message
        
        setupCellDetails()
    }
    
    func configureCell(recItem: AspireRecItem, count: Int) {
        titleMsg.text = recItem.aspireTo
        dateMsg.text = recItem.date
        detailMsg.text = recItem.aspireReasons
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

protocol LetterTableCellDelegate: class {
    func updateHeightOfRow(_ cell: LetterRecTableViewCell, _ textView: UITextView)
}

extension LetterRecTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
}
