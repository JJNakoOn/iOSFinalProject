//
//  ClueTableViewCell.swift
//  ARKitImageRecognition
//
//  Created by yihsuanlee on 2018/6/11.
//  Copyright © 2018年 Jayven Nhan. All rights reserved.
//

import UIKit

class ClueTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var detail: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var clueState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
