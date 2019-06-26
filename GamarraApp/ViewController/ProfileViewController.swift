//
//  ProfileViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController {

    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func logoutButtonItemTapped(_ sender: Any) {
        defaults.set(0, forKey: "id")
        defaults.set("", forKey: "accessToken")
        self.performSegueToReturnBack()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
