//
//  UIImageViewExtension.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import Foundation
import UIKit
import os

extension UIImageView {
    func setImage(fromAsset assetName: String?) {
        if let name = assetName {
            DispatchQueue.main.async {
                self.image = UIImage(named: name)
            }
        }
    }
    
    func log(_ message: String) {
        os_log("%@", message)
    }
    
    func setImage(
        fromUrlString urlString: String,
        withDefaultImage defaultImage: String?,
        withErrorImage errorImage: String?) {
        self.setImage(fromAsset: defaultImage)
        guard let url = URL(string: urlString) else {
            self.log("Error while building URL, default image assigned")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let urlResponse = response as? HTTPURLResponse,
                urlResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data) else {
                    self.log("Error while requesting Image, error image assigned: \(error?.localizedDescription ?? "Error")")
                    return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}

