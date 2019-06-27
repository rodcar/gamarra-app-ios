//
//  NewBusinessViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/27/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class NewBusinessViewController: UIViewController {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var businessUrllogoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerBusinessButtonTapped(_ sender: Any) {
        let name = self.businessNameTextField.text
        let urllogo = self.businessUrllogoTextField.text
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

extension NewBusinessViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
