//
//  BagViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BagViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clothBagTableView: UITableView!
    
    var clothes: [JSON] = [JSON]()
    var defaults = UserDefaults.standard
    var userId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        checkSignIn()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkSignIn()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothBagCell") as! UITableViewCell
        cell.textLabel?.text = clothes[indexPath.row]["name"].stringValue
        return cell
    }
    
    func checkSignIn() {
        userId = defaults.integer(forKey: "id")
        
        if userId != 0 {
            loadClothMarked()
        } else {
            print("El usuario no esta autenticado")
            clothes = [JSON]()
            self.clothBagTableView.reloadData()
        }
    }
    
    func loadClothMarked() {
        let accessToken = defaults.string(forKey: "accessToken")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        AF.request("https://quiet-temple-50701.herokuapp.com/users/\(userId)/markers", headers: headers).responseJSON {
            response in
            
            switch response.result {
            case let .success(value):
                self.clothes = JSON(value).array!
                self.clothBagTableView.reloadData()
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
