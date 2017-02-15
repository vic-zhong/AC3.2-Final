//
//  PicsTableViewCell.swift
//  AC3.2-Final
//
//  Created by Victor Zhong on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class PicsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
