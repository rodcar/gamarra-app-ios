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
    
    @IBOutlet weak var clothesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "clothTableViewCell")
        cell.textLabel?.text = clothes[indexPath.row]["name"].stringValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
        performSegue(withIdentifier: "showClothDetailSegue", sender: self)
    }
}
