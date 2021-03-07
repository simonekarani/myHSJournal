//
//  DailyTodoTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/28/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class DailyTodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoBtn: UIButton!
    @IBOutlet weak var todoTask: UILabel!
    
    var planRecType: Int = 0
    var planRecItem:DailyPlanRecItem!
    var yearlyPlanRecItem:YearlyPlanRecItem!
    var goalPlanRecItem:GoalPlanRecItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        todoBtn.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        todoBtn.setImage(UIImage(named:"Checkmark"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(recItem: DailyPlanRecItem) {
        planRecType = 1
        todoTask.text = recItem.taskDetails!
        if recItem.completed {
            todoBtn.isSelected = true
        } else {
            todoBtn.isSelected = false
        }
        todoBtn.transform = .identity
        planRecItem = recItem

        setupCellDetails()
    }
    
    func configureCell(recItem: YearlyPlanRecItem) {
        planRecType = 2
        todoTask.text = recItem.yearlyDetails!
        if recItem.completed {
            todoBtn.isSelected = true
        } else {
            todoBtn.isSelected = false
        }
        todoBtn.transform = .identity
        yearlyPlanRecItem = recItem
        
        setupCellDetails()
    }
    
    func configureCell(recItem: GoalPlanRecItem) {
        planRecType = 3
        todoTask.text = recItem.taskDetails!
        if recItem.completed {
            todoBtn.isSelected = true
        } else {
            todoBtn.isSelected = false
        }
        todoBtn.transform = .identity
        goalPlanRecItem = recItem
        
        setupCellDetails()
    }
    
    func setupCellDetails() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    @IBAction func todoSelected(_ sender: UIButton) {
        if planRecType == 1 {
            planRecItem.completed = !sender.isSelected
        } else if planRecType == 2 {
            yearlyPlanRecItem.completed = !sender.isSelected
        } else {
            goalPlanRecItem.completed = !sender.isSelected
        }
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
