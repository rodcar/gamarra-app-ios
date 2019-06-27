//
//  ShopDetailViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/25/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var shopAddressLabel: UILabel!
    
    
    var shopId: Int = 0
    var shopAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.shopAddressLabel.text = shopAddress
        print("address: \(shopAddress)")
    }

}
