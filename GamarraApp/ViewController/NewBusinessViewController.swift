//
//  NewBusinessViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/27/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewBusinessViewController: UIViewController {
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var businessUrllogoTextField: UITextField!
    
    var defaults = UserDefaults.standard
    var newBusinessId: Int = 0
    var newBusinessName: String = ""
    var newBusinessUrllogo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerBusinessButtonTapped(_ sender: Any) {
        self.newBusinessName = self.businessNameTextField.text!
        self.newBusinessUrllogo = self.businessUrllogoTextField.text!
        
        let accessToken = defaults.string(forKey: "accessToken")
        let userId = defaults.integer(forKey: "id")
        print(accessToken ?? "")
        
        let parameters: [String : Any] = [
            "id": 0,
            "name": self.newBusinessName,
            "urllogo": self.newBusinessUrllogo,
            "userId": [
                "birthdate": "2019-06-27T19:58:47.636Z",
                "dni": "string",
                "email": "string",
                "fathersLastName": "string",
                "firstName": "string",
                "gender": true,
                "id": userId,
                "mothersLastName": "string",
                "name": "string",
                "password": "string",
                "roles": [
                [
                "id": 0,
                "name": "ROLE_USER"
                ]
                ],
                "secondName": "string",
                "username": "string"
            ]
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/businesses", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            let statusCode = response.response?.statusCode
            print(statusCode)
            if statusCode == 201 {
                print("El negocio se ha registrado")
                let location = (response.response?.allHeaderFields as? [String : String])?["Location"]
                //print(location)
                //print(location?["Location"])
                let lastSlash = location!.index(after: location!.lastIndex(of: "/")!)
                let newBusinessIdResponse = location![lastSlash...]
                print(newBusinessIdResponse)
                self.newBusinessId = Int(String(newBusinessIdResponse))!
                
                self.performSegue(withIdentifier: "showBusinessDetailFromRegisterSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusinessDetailFromRegisterSegue" {
            let destination = segue.destination as! BusinessDetailViewController
            destination.setBusiness(WithId: self.newBusinessId, WithName: self.newBusinessName, WitUrllogo: self.newBusinessName)
        }
    }

}

extension NewBusinessViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
