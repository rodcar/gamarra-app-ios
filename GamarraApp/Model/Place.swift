//
//  Place.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
