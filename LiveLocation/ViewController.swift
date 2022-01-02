//
//  ViewController.swift
//  LiveLocation
//
//  Created by Rishad Appat on 02/01/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKPointAnnotation?
    var locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.didUpdateLocations = {(clLocation) in
            if let location = clLocation.last
            {
                print(location)
                self.addMarker(to: location)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopListening()
    }
    
    private func addMarker(to location: CLLocation)
    {
        if(self.annotation == nil)
        {
            self.annotation = MKPointAnnotation()
            self.mapView.addAnnotation(annotation!)
        }
        UIView.animate(withDuration: 0.3) {
            self.annotation?.coordinate = location.coordinate
        }
        let center = location.coordinate
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
}

