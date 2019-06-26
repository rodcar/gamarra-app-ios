//
//  BusinessesViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/25/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BusinessesViewController: UIViewController {

    
    @IBOutlet weak var businessesTableView: UITableView!
    
    var defaults = UserDefaults.standard
    var businesses: [JSON] = [JSON]()
    var currentRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBusinesses()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadBusinesses()
    }
    
    func loadBusinesses() {
        let userId = defaults.integer(forKey: "id")
        let accessToken = defaults.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        AF.request("https://quiet-temple-50701.herokuapp.com/users/\(userId)/businesses", headers: headers).responseJSON {
            response in
            
            switch response.result {
            case let .success(value):
                self.businesses = JSON(value).array!
                self.businessesTableView.reloadData()
                break
            case let .failure(error):
                break
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusinessDetailSegue" {
            let destination = segue.destination as! BusinessDetailViewController
            let business = businesses[currentRow]
            destination.setBusiness(WithId: business["id"].intValue, WithName: business["name"].stringValue, WitUrllogo: business["urllogo"].stringValue)
        }
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath)
        cell.textLabel?.text = businesses[indexPath.row]["name"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
        performSegue(withIdentifier: "showBusinessDetailSegue", sender: self)
    }
}
