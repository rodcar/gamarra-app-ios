//
//  ClothDetailViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ClothDetailViewController: ViewController {

    var cloth: Cloth?
    
    @IBOutlet weak var clothNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clothNameLabel.text = cloth?.name
    }
}
