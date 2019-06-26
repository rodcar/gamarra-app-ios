//
//  GamarraApi.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import os

class GamarraApi {
    static let baseUrlString = "https://quiet-temple-50701.herokuapp.com"
    static let sourcesUrlString = "\(baseUrlString)/v2/sources"
    static let topHeadlinesUrlString = "\(baseUrlString)/v2/top-headlines"
    static let everythingUrlString = "\(baseUrlString)/v2/everything"
    static let signInUrlString = "\(baseUrlString)/api/auth/signin"
    
    static private func get<T: Decodable>(
        from urlString: String,
        parameters: [String : String],
        responseType: T.Type,
        responseHandler: @escaping ((T) -> Void),
        errorHandler: @escaping ((Error) -> Void)) {
        guard let url = URL(string: urlString) else {
            let message = "Error on URL"
            os_log("%@", message)
            return
        }
        AF.request(url, parameters: parameters).validate().responseJSON(
            completionHandler: { response in
                switch response.result {
                case .success( _):
                    do {
                        let decoder = JSONDecoder()
                        if let data = response.data {
                            let dataResponse = try decoder.decode(responseType, from: data)
                            responseHandler(dataResponse)
                        }
                    } catch {
                        errorHandler(error)
                    }
                    
                case .failure(let error):
                    errorHandler(error)
                }
        })
    }
    
    static func signIn(WithUsername username: String, WithPassword password: String, responseHandler: @escaping (() -> ()), authErrorHandler: @escaping (() -> ())) {
        let parameters = [
            "username": username,
            "password": password
        ]
        
        AF.request("https://quiet-temple-50701.herokuapp.com/api/auth/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response.description)
            switch response.result {
            case let .success(value):
                if response.response?.statusCode == 200 {
                    let authResponse = JSON(value).dictionary!
                    print(authResponse["id"]?.intValue)
                    print(authResponse["accessToken"]?.stringValue)
                    let userId = authResponse["id"]?.intValue
                    let accessToken = authResponse["accessToken"]?.stringValue
                    UserDefaults.standard.set(userId, forKey: "id")
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")

                    responseHandler()
                } else {
                    print("Hubo un problema al autenticarse")
                    let alert = UIAlertController(title: "Ingreso", message: "el usuario y la constrasena no coinciden.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    /*alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                     alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))*/
                
                }
                break
            case let .failure(error):
                break
            }
        }
    }
    
}
