//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Baraa Hesham on 2/11/19.
//  Copyright © 2019 Baraa Hesham. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewImage: UIImageView!
    
    
    @IBOutlet weak var tableLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
