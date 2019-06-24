//
//  ClothCategoryViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/24/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClothCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clothCategoryResultsTableView: UITableView!
    
    var categoryId: Int = 0
    var categoryTitle: String = ""
    var clothes: [JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = categoryTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadClothCategory()
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothCategoryCell", for: indexPath) as! ClothCategoryTableViewCell
        let cloth = clothes[indexPath.row]
        cell.clothCategoryResultImageView.setImage(fromUrlString: cloth["urlphoto"].stringValue, withDefaultImage: "no-image-available", withErrorImage: "no-image-available")
        cell.clothCategoryResultLabel.text = cloth["name"].stringValue
        //cell.textLabel?.text = cloth["name"].stringValue
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadClothCategory() {
        AF.request("https://quiet-temple-50701.herokuapp.com/categories/\(categoryId)/clothes").responseJSON {
            response in
            switch response.result {
            case let .success(value):
                self.clothes = JSON(value).array!
                self.clothCategoryResultsTableView.reloadData()
                break
            case let .failure(error):
                break
            }
        }
    }

}
