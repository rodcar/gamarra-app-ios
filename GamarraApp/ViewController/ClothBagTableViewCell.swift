//
//  ClothBagTableViewCell.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ClothBagTableViewCell: UITableViewCell {

    @IBOutlet weak var clothBagImageView: UIView!
    @IBOutlet weak var clothBagNameLabel: UILabel!
    
    @IBOutlet weak var clothBagCellImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
