//
//  GoalsListTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/26/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class GoalsListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!   
    @IBOutlet weak var checkLbl: UILabel!
    
    var goalRecItem: GoalsRecItem!
    weak var cellDelegate: GoalsListTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        checkBtn.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        checkBtn.setImage(UIImage(named:"Checkmark"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(recItem: GoalsRecItem) {
        dateLbl.text = recItem.dateSet
        checkLbl.text = recItem.title! + "\n - " + recItem.goalDetails!
        if recItem.completed {
            checkBtn.isSelected = true
        } else {
            checkBtn.isSelected = false
        }
        checkBtn.transform = .identity
        goalRecItem = recItem
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    @IBAction func checkSelected(_ sender: UIButton) {
        goalRecItem.completed = !sender.isSelected
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
}

protocol GoalsListTableCellDelegate: class {
    func updateHeightOfRow(_ cell: GoalsListTableViewCell, _ textView: UITextView)
}

extension GoalsListTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
}
