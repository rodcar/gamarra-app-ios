//
//  BusinessDetailViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/25/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessLogoImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var shopsTableView: UITableView!
    
    var businessId: Int = 0
    var businessUrllogo: String = ""
    var businessName: String = ""
    var defaults = UserDefaults.standard
    var shops: [JSON] = [JSON]()
    var currentRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.businessLogoImageView.setImage(fromUrlString: self.businessUrllogo, withDefaultImage: "no-image-available", withErrorImage: "no-image-available")
        self.businessNameLabel.text = self.businessName
        loadShops()
    }

    func setBusiness(WithId id: Int, WithName name: String, WitUrllogo urllogo: String) {
        self.businessId = id
        self.businessUrllogo = urllogo
        self.businessName = name
    }

    func loadShops() {
        let userId = defaults.integer(forKey: "id")
        AF.request("https://quiet-temple-50701.herokuapp.com/users/\(userId)/businesses/\(businessId)/shops").responseJSON {
            response in
            switch response.result {
            case let .success(value):
                self.shops = JSON(value).array!
                self.shopsTableView.reloadData()
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClothDetailSegue" {
            let destination = segue.destination as! ShopDetailViewController
            destination.shopId = shops[currentRow].intValue
            destination.shopAddress = shops[currentRow].stringValue
        }
    }

}

extension BusinessDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopBusinessCell", for: indexPath)
        cell.textLabel?.text = self.shops[indexPath.row]["address"].stringValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentRow = indexPath.row
        performSegue(withIdentifier: "showClothDetailSegue", sender: self)
    }
}
