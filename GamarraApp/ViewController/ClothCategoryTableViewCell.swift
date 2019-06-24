//
//  ClothCategoryTableViewCell.swift
//  GamarraApp
//
//  Created by user155748 on 6/24/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ClothCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var clothCategoryResultImageView: UIImageView!
    @IBOutlet weak var clothCategoryResultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
