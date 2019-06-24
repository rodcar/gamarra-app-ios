//
//  ClothResultsViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClothResultsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchText = ""
    var currentRow: Int = 0
    var clothes: [JSON] = [JSON]()
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var clothesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothesTableView.isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        //longPressGesture.minimumPressDuration = 0.5 // 1 second press
        
        clothesTableView.addGestureRecognizer(longPressGesture)
        print("Se recibio \(searchText)")
        AF.request("https://quiet-temple-50701.herokuapp.com/clothes?name=\(searchText)").responseJSON{response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
                case let .success(value):

                        print("JSON: \(value)") // serialized json response
                        self.clothes = JSON(value).array!
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                    }
                    
                        self.clothesTableView.reloadData()
                    break
                case let .failure(error):
                    
                    break
            }
            

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClothDetailSegue" {
            let destination = segue.destination as! ClothDetailViewController
            destination.cloth = Cloth(withId: clothes[currentRow]["id"].intValue, withName: clothes[currentRow]["name"].stringValue, withDescription: clothes[currentRow]["description"].stringValue, withUrlphoto: clothes[currentRow]["urlphoto"].stringValue)
            
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = clothesTableView.dequeueReusableCell(withIdentifier: "clothTableViewCell", for: indexPath) as! ClothTableViewCell
        //cell.textLabel?.text = clothes[indexPath.row]["name"].stringValue
        let cloth = Cloth(withId: clothes[indexPath.row]["id"].intValue, withName: clothes[indexPath.row]["name"].stringValue, withDescription: clothes[indexPath.row]["description"].stringValue, withUrlphoto: clothes[indexPath.row]["urlphoto"].stringValue)
        
        cell.clothPhotoPreviewImageView.setImage(fromUrlString: cloth.urlphoto ?? "no-image-available", withDefaultImage: "no-image-available", withErrorImage: "no-image-available")
        cell.clothResultLabel.text = cloth.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
        performSegue(withIdentifier: "showClothDetailSegue", sender: self)
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.clothesTableView)
            if let indexPath = clothesTableView.indexPathForRow(at: touchPoint) {
                let cloth = clothes[indexPath.row]
                print("\(cloth["name"].stringValue)")
                mark(cloth["id"].intValue)
            }
        }
    }
    
    func mark(_ clothId: Int) {
        let userId = defaults.integer(forKey: "id")
        let accessToken = defaults.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let parameters = [
            "id": clothId
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/users/\(userId)/markers", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON {
            response in
            //TODO deberia mostrarse al obtene una respuesta del servicio de que se registro
            self.view.displayToast("Se agrego a la bolsa!")
            switch response.result {
            case let .success(value):
                    print("El marcador se guardo correctamente")
                    self.view.displayToast("Se agrego a la bolsa!")
                break
            case let .failure(error):
                print("No se pudo guardar el marcador")
                print(response.response?.statusCode)
                break
            }
        }
    }
}
