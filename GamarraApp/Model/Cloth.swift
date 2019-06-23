//
//  Cloth.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import Foundation

class Cloth: Codable {
    var id: Int
    var name: String?
    var description: String?
    var urlphoto: String?
    
    init(withId id: Int, withName name: String?, withDescription description: String?, withUrlphoto urlphoto: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.urlphoto = urlphoto
    }
}
