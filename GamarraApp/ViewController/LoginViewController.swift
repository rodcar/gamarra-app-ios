//
//  LoginViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: ViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        checkUserSignIn()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/api/auth/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response.description)
            switch response.result {
                case let .success(value):
                    if response.response?.statusCode == 200 {
                    let authResponse = JSON(value).dictionary!
                    print(authResponse["id"]?.intValue)
                    print(authResponse["accessToken"]?.stringValue)
                    let userId = authResponse["id"]?.intValue
                    let accessToken = authResponse["accessToken"]?.stringValue
                    self.defaults.set(userId, forKey: "id")
                    self.defaults.set(accessToken, forKey: "accessToken")
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    self.showProfile()
                    } else {
                        print("Hubo un problema al autenticarse")
                        let alert = UIAlertController(title: "Ingreso", message: "el usuario y la constrasena no coinciden.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                        /*alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))*/
                        
                        self.present(alert, animated: true)
                    }
                    break
                case let .failure(error):
                    break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkUserSignIn() {
        let userId = defaults.integer(forKey: "id")
        
        if userId != 0 {
            showProfile()
        }
    }
    
    func showProfile() {
        performSegue(withIdentifier: "showProfileSegue", sender: self)
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
