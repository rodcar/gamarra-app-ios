//
//  ShopDetailViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/25/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var clothesShopTableView: UITableView!
    
    var shopId: Int = 0
    var shopAddress: String = ""
    var clothes: [JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.shopAddressLabel.text = shopAddress
        loadClothes()
    }
    
    func loadClothes() {
        AF.request("https://quiet-temple-50701.herokuapp.com/shops/\(shopId)/clothes").responseJSON {
            response in
            switch response.result {
            case let .success(value):
                self.clothes = JSON(value).array!
                self.clothesShopTableView.reloadData()
                break
            case let .failure(error):
                break
            }
        }
    }

}

extension ShopDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothShopCell", for: indexPath) as! ClothShopTableViewCell
        let cloth = clothes[indexPath.row]
        cell.clothImageView.setImage(fromUrlString: cloth["urlphoto"].stringValue, withDefaultImage: "no-image-available", withErrorImage: "no-image-available")
        cell.clothNameLabel.text = cloth["name"].stringValue
        return cell
    }
    
    
}
