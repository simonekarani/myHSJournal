//
//  HSRecDetailTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/25/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import UIKit

class HSRecDetailTableViewCell: UITableViewCell {
    
    weak var cellDelegate: GrowingCellProtocol?

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var inputViewScreen: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailDescription.delegate = (self as UITextViewDelegate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setInputView(inputScreen: String) {
        inputViewScreen = inputScreen
    }
    
    func configureCell(recItem: HSRecItem, count: Int) {
        if (count == 0) {
            detailLabel.text = "No \(recItem.title!) Records"
            gradeLabel.text = ""
        } else {
            if inputViewScreen == "MyAchievementScreen" {
                detailLabel.text = "[\(recItem.schoolyear?.description ?? "")] - \(recItem.title!)"
            } else {
                detailLabel.text = recItem.title!
            }
            gradeLabel.text = recItem.grade!
            detailDescription.text = recItem.recognition!
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

protocol GrowingCellProtocol: class {
    func updateHeightOfRow(_ cell: HSRecDetailTableViewCell, _ textView: UITextView)
}

extension HSRecDetailTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
}
