//
//  CustomTableViewCell.swift
//  RealmSwift5
//
//  Created by 酒井専冴 on 2020/04/07.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
