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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    
}
