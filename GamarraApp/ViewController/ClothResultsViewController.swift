//
//  ClothResultsViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/22/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import Alamofire

class ClothResultsViewController: ViewController {
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Se recibio \(searchText)")
        AF.request("https://quiet-temple-50701.herokuapp.com/clothes").responseJSON{response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            switch response.result {
                case let .success(value):

                        print("JSON: \(value)") // serialized json response

                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                    }
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
