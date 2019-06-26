//
//  ProfileViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: ViewController {

    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    var defaults = UserDefaults.standard
    var options : [String] = [
        "Negocios",
        "Suscripcion"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userId = defaults.integer(forKey: "id")
        let accessToken = defaults.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "" )"
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/users/\(userId)", headers: headers).responseJSON {
            response in
            switch response.result {
            case let.success(value):
                let responseStatusCode = response.response?.statusCode
                if responseStatusCode == 200 {
                    let user = JSON(value).dictionaryValue
                    self.welcomeMessageLabel.text = "Bienvenido \(user["name"]!.stringValue)"
                }
                break
            case let .failure(error):
                break
            }
        }
    }
    
    
    @IBAction func logoutButtonItemTapped(_ sender: Any) {
        defaults.set(0, forKey: "id")
        defaults.set("", forKey: "accessToken")
        self.performSegueToReturnBack()
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


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileOptionCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            performSegue(withIdentifier: "showBusinessesSegue", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "showSuscriptionsSegue", sender: self)
            break
        default:
            print("default case")
            break
        }
    }
}
