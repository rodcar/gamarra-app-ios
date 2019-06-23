//
//  GamarraApi.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import Foundation
import Alamofire
import os

class GamarraApi {
    static let baseUrlString = "https://newsapi.org"
    static let sourcesUrlString = "\(baseUrlString)/v2/sources"
    static let topHeadlinesUrlString = "\(baseUrlString)/v2/top-headlines"
    static let everythingUrlString = "\(baseUrlString)/v2/everything"
    
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
    
    
}
