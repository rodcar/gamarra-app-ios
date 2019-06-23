//
//  ShopMapViewController.swift
//  GamarraApp
//
//  Created by user155748 on 6/23/19.
//  Copyright © 2019 Developer User. All rights reserved.
//

import UIKit
import MapKit

class ShopMapViewController: ViewController {

    @IBOutlet weak var shopMapView: MKMapView!
    @IBOutlet weak var shopAddressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var shopPlace: Place = Place(
        title: "Rome",
        coordinate: CLLocationCoordinate2D(
            latitude: 41.9,
            longitude: 12.5),
        info: "A city with a country inside.")
    var shopAddress: String = ""
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            shopMapView.showsUserLocation = true
            shopMapView.showsScale = true
            shopMapView.showsCompass = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopMapView.delegate = self
        
        /*let rome = Place(
            title: "Rome",
            coordinate: CLLocationCoordinate2D(
                latitude: 41.9,
                longitude: 12.5),
            info: "A city with a country inside.")*/
        shopMapView.addAnnotations([shopPlace])
        shopMapView.showAnnotations(shopMapView.annotations, animated: true)
        self.shopAddressLabel.text = shopAddress
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthorizationStatus()
    }

}

extension ShopMapViewController: MKMapViewDelegate {
    // Custom View for Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Place else { return nil }
        let identifier = "Place"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    // Place Info View
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let place = view.annotation as? Place else { return }
        let placeTitle = place.title
        let placeInfo = place.info
        let alert = UIAlertController(
            title: placeTitle,
            message: placeInfo,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil))
        present(alert, animated: true)
    }
}
