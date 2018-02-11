//
//  ClassCell.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2018/2/8.
//  Copyright © 2018年 Cheio Wright. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
