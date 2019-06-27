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
    var defaults = UserDefaults.standard
    
    var categories: [JSON] = [JSON]()
    var selectedCategoryId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothNameTextField.delegate = self
        clothDescriptionTextField.delegate = self
        clothUrlPhotoTextField.delegate = self
        categoryPickerView.delegate = self
        // Do any additional setup after loading the view.
        loadCategories()
    }

    @IBAction func registerButtonDidTapped(_ sender: Any) {
        let userId = defaults.integer(forKey: "id")
        let accessToken = defaults.string(forKey: "accessToken")
        
        let name = self.clothNameTextField.text
        let description = self.clothDescriptionTextField.text
        let urlphoto = self.clothUrlPhotoTextField
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let parameters: [String : Any] = [
            "categoryId": [
                "id": 0,
                "name": name
            ],
            "description": description,
            "name": "string",
            "sizeId": [
                "id": 0,
                "name": "string"
            ],
            "urlphoto": "string"
        ]
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
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]["name"].stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategoryId = categories[row]["id"].intValue
    }
    
}
