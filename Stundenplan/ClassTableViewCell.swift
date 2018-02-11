//
//  ClassTableViewCell.swift
//  Stundenplan
//
//  Created by Cheio Wright on 2017/10/31.
//  Copyright © 2017年 Cheio Wright. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classLocationLabel: UILabel!
    @IBOutlet weak var classTeacherLabel: UILabel!
    @IBOutlet weak var classNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with singleClass: Class) {
        classNameLabel.text = singleClass.name
        classLocationLabel.text = singleClass.location
        classTeacherLabel.text = singleClass.teacher
    }
}
