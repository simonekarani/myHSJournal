//
//  DidIDoTableViewCell.swift
//  happykids
//
//  Created by Simone Karani on 7/10/21.
//

import UIKit

class DidIDoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var didText: UILabel!
    @IBOutlet weak var didImg: UIImageView!
    
    var isCheckSelected:Bool? = false
    
    // Inside our custom cell
    weak var delegate: MyDayTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBtn.setImage(UIImage(named:"checkempty"), for: .normal)
        checkBtn.setImage(UIImage(named:"checkmark"), for: .selected)
    }
    
    func configureCell(cellText: String, cellImg: UIImage, cellSelected: Bool) {
        didText.text = cellText
        didImg.image = cellImg
        checkBtn.isSelected = cellSelected
        checkBtn.transform = .identity
        isCheckSelected = cellSelected

        setupCellDetails()
    }

    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkBtnSelected(_ sender: UIButton) {
        checkBtn.isSelected = true
        delegate?.toggleCheckmark(for: self)
        isCheckSelected = true

        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }

        delegate?.updateTableView()
    }
}
