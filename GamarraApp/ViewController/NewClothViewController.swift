//
//  NewClothViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/25/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewClothViewController: UIViewController {

    @IBOutlet weak var clothNameTextField: UITextField!
    @IBOutlet weak var clothDescriptionTextField: UITextField!
    @IBOutlet weak var clothUrlPhotoTextField: UITextField!
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet weak var sizePickerView: UIPickerView!
    
    var defaults = UserDefaults.standard
    
    var categories: [JSON] = [JSON]()
    var sizes: [JSON] = [JSON]()
    var selectedCategoryId: Int = 0
    var selectedSizeId: Int = 0
    var clothId: Int = 0
    var clothName: String = ""
    var clothDescription: String = ""
    var clothUrlphoto: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothNameTextField.delegate = self
        clothDescriptionTextField.delegate = self
        clothUrlPhotoTextField.delegate = self
        categoryPickerView.delegate = self
        sizePickerView.delegate = self
        // Do any additional setup after loading the view.
        loadCategories()
        loadSizes()
    }

    @IBAction func registerButtonDidTapped(_ sender: Any) {
        
        self.clothName = self.clothNameTextField.text!
        self.clothDescription = self.clothDescriptionTextField.text!
        self.clothUrlphoto = self.clothUrlPhotoTextField.text!
        
        let parameters: [String : Any] = [
            "id":0,
            "categoryId": [
                "id": selectedCategoryId,
                "name": ""
            ],
            "description": clothDescription ?? "",
            "name": clothName ?? "",
            "sizeId": [
                "id": selectedSizeId,
                "name": ""
            ],
            "urlphoto": clothUrlphoto ?? ""
        ]
        print(parameters)
        saveCloth(WithParameters: parameters)
    }
    
    func loadCategories() {
        AF.request("https://quiet-temple-50701.herokuapp.com/categories").responseJSON {
            response in
            switch response.result {
            case let .success(value):
                self.categories = JSON(value).array!
                self.categoryPickerView.reloadAllComponents()
                break
            case let .failure(error):
                break
            }
        }
    }
    
    func loadSizes() {
        AF.request("https://quiet-temple-50701.herokuapp.com/sizes").responseJSON {
            response in
            print("response's status: \(response.response?.statusCode)")
            switch response.result {
            case let .success(value):
                self.sizes = JSON(value).array!
                self.sizePickerView.reloadAllComponents()
                break
            case let .failure(error):
                break
            }
        }
    }
    
    // TODO Se debe asociar la prenda con la tienda
    func saveCloth(WithParameters parameters: [String :  Any]) {
        let accessToken = defaults.string(forKey: "accessToken")
        print(accessToken ?? "")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        print(headers[0])
        
        AF.request("https://quiet-temple-50701.herokuapp.com/clothes", method: .post,  parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if response.response?.statusCode == 201 {
                print("La prenda ha sido creada")
                let location = (response.response?.allHeaderFields as? [String : String])?["Location"]
                //print(location)
                //print(location?["Location"])
                let lastSlash = location!.index(after: location!.lastIndex(of: "/")!)
                let newClothId = location![lastSlash...]
                print(newClothId)
                self.clothId = Int(String(newClothId))!
                self.performSegueToClothDetail()
            }
            /*switch response.result {
            case let .success(value):
                print(response.response?.statusCode)
                print(value)
                break
            case let .failure(error):
                print(error)
                print(error.localizedDescription)
                break
            }*/
        }
    }
    
    func performSegueToClothDetail(){
        self.performSegue(withIdentifier: "showClothDetailFromRegisterSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClothDetailFromRegisterSegue" {
            let destination = segue.destination as! ClothDetailViewController
            destination.cloth = Cloth(withId: self.clothId, withName: self.clothName, withDescription: self.clothDescription, withUrlphoto: self.clothUrlphoto)
        }
    }
    
}

extension NewClothViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewClothViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "categoryPickerView" {
            return self.categories.count
        } else if pickerView.accessibilityIdentifier == "sizePickerView"{
            return self.sizes.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "categoryPickerView" {
            return self.categories[row]["name"].stringValue
        } else if pickerView.accessibilityIdentifier == "sizePickerView"{
            return self.sizes[row]["name"].stringValue
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.accessibilityIdentifier == "categoryPickerView" {
            self.selectedCategoryId = categories[row]["id"].intValue
        } else if pickerView.accessibilityIdentifier == "sizePickerView"{
            self.selectedSizeId = sizes[row]["id"].intValue
        }
    }
    
}
