//
//  CategoriesViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CategoriesViewController: ViewController {

    @IBOutlet weak var clothSearchBar: UISearchBar!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var searchText = ""
    var categories: [JSON] = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothSearchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCategories()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let clothResultsViewController = segue.destination as! ClothResultsViewController
        clothResultsViewController.searchText = self.searchText
    }
    
    func loadCategories() {
        AF.request("https://quiet-temple-50701.herokuapp.com/categories").responseJSON {
            response in
            
            switch response.result {
            case let .success(value):
                self.categories = JSON(value).array!
                self.categoriesTableView.reloadData()
                break
            case let.failure(error):
                break
            }
        }
    }
    
}

extension CategoriesViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        print("Buscaste \(searchText)")
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "showClothResults", sender: self)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelo la busqueda")
        
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]["name"].stringValue
        return cell
    }
    
    
}
