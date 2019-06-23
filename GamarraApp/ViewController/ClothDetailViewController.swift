//
//  ClothDetailViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class ClothDetailViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
  
    var cloth: Cloth?
    var shops: [JSON] = [JSON]()
    var currentShopRow: Int = 0
    
    @IBOutlet weak var clothPhotoImageView: UIImageView!
    @IBOutlet weak var clothNameLabel: UILabel!
    @IBOutlet weak var clothDescriptionLabel: UILabel!
        @IBOutlet weak var shopsResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clothNameLabel.text = cloth?.name
        clothPhotoImageView.setImage(fromUrlString: cloth!.urlphoto ?? "no-image-available", withDefaultImage: "no-image-available", withErrorImage: "no-image-available")
        clothDescriptionLabel.text = cloth?.description
        
        AF.request("https://quiet-temple-50701.herokuapp.com/clothes/\(String(cloth!.id))/shops")
            .responseJSON { response in
                switch response.result {
                case let .success(value):
                    self.shops = JSON(value).array ?? [JSON]()
                    self.shopsResultsTableView.reloadData()
                    break
                case let .failure(error):
                    break
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shopsResultsTableView.dequeueReusableCell(withIdentifier: "shopTableViewCell", for: indexPath)
        cell.textLabel!.text = shops[indexPath.row]["address"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentShopRow = indexPath.row
        performSegue(withIdentifier: "showShopMapSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShopMapSegue" {
            let destination = segue.destination as! ShopMapViewController
            let currentShop = shops[currentShopRow]
            destination.shopPlace = Place(
                title: currentShop["address"].stringValue,
                coordinate: CLLocationCoordinate2D(
                    latitude: currentShop["latitude"].doubleValue,
                    longitude: currentShop["longitude"].doubleValue),
                info: currentShop["directions"].stringValue)
            destination.shopAddress = currentShop["address"].stringValue 
        }
    }
}
