//
//  ClothShopTableViewCell.swift
//  GamarraApp
//
//  Created by user155748 on 6/26/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ClothShopTableViewCell: UITableViewCell {

    @IBOutlet weak var clothImageView: UIImageView!
    @IBOutlet weak var clothNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
