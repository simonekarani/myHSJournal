//
//  RecordsTableViewCell.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/14/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var hsYearImg: UIImageView!
    
    @IBOutlet weak var hsYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
