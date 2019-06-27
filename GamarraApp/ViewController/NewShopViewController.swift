//
//  NewShopViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/27/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewShopViewController: UIViewController {

    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var shopReferencesTextField: UITextField!
    @IBOutlet weak var shopUrlphotoTextField: UITextField!
    @IBOutlet weak var galleryPickerView: UIPickerView!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var loguitudeTextField: UITextField!
    
    var galleries: [JSON] = [JSON]()
    var selectedGalleryId: Int = 0
    var defaults = UserDefaults.standard
    
    var businessId: Int = 0
    
    var shopAddress: String = ""
    var shopReferences: String = ""
    var shopUrlphoto: String = ""
    var shopLatitude: Double = 0.0
    var shopLongitude: Double = 0.0
    var newShopId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopAddressTextField.delegate = self
        shopReferencesTextField.delegate = self
        shopUrlphotoTextField.delegate = self
        latitudeTextField.delegate = self
        loguitudeTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadGalleries()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userId = defaults.integer(forKey: "id")
        let accessToken = defaults.string(forKey: "accessToken")
        
        self.shopAddress = self.shopAddressTextField.text!
        self.shopUrlphoto = self.shopUrlphotoTextField.text!
        self.shopLongitude = Double(self.loguitudeTextField.text!) as! Double
        self.shopLatitude = Double(self.latitudeTextField.text!) as! Double

        let parameters: [String : Any] = [
            "address": self.shopAddress,
            "businessId": [
                "id": self.businessId,
                "name": "string",
                "urllogo": "string",
                "userId": [
                    "birthdate": "2019-06-27T20:50:58.849Z",
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
            ],
            "directions": "string",
            "galleryId": [
                "address": "string",
                "id": self.selectedGalleryId,
                "latitude": 0,
                "longitude": 0,
                "name": "string"
            ],
            "id": 0,
            "latitude": self.shopLatitude,
            "longitude": self.shopLongitude,
            "urlphoto": self.shopUrlphoto
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/shops", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            let statusCode = response.response?.statusCode
            print(statusCode)
            if statusCode == 201 {
                print("La tienda se ha registrado")
                let location = (response.response?.allHeaderFields as? [String : String])?["Location"]
                print(location)
                let lastSlash = location!.index(after: location!.lastIndex(of: "/")!)
                let newShopIdResponse = location![lastSlash...]
                print(newShopIdResponse)
                self.newShopId = Int(String(newShopIdResponse))!
                self.performSegue(withIdentifier: "showShopFromRegisterSegue", sender: self)
            }
        }
        
    }
    
    func loadGalleries() {
        AF.request("https://quiet-temple-50701.herokuapp.com/galleries").responseJSON {
            response in
            print("response's status: \(response.response?.statusCode)")
            switch response.result {
            case let .success(value):
                self.galleries = JSON(value).array!
                self.galleryPickerView.reloadAllComponents()
                self.selectedGalleryId = self.galleries[0]["id"].intValue
                break
            case let .failure(error):
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShopFromRegisterSegue" {
            let destination = segue.destination as! ShopDetailViewController
            destination.shopId = self.newShopId
            destination.shopAddress = self.shopAddress
        }
    }
    
}
extension NewShopViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewShopViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.galleries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.galleries[row]["name"].stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedGalleryId = self.galleries[row]["id"].intValue
    }

}

