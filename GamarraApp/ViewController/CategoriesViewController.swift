//
//  CategoriesViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit

class CategoriesViewController: ViewController {

    @IBOutlet weak var clothSearchBar: UISearchBar!
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clothSearchBar.delegate = self
        
        // Do any additional setup after loading the view.
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
    
}

extension CategoriesViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        print("Buscaste \(searchText)")
        performSegue(withIdentifier: "showClothResults", sender: self)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelo la busqueda")
    }
}
