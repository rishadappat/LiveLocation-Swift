//
//  LocationManager.swift
//  SmartOfficer
//
//  Created by Rishad Appat on 23/07/2020.
//  Copyright © 2020 ADP. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locManager = CLLocationManager()
    var didUpdateLocations: (([CLLocation]) -> Void)?
    var failed: (() -> Void)?
    var didPermissiongGranded: (() -> Void)?
    
    override init() {
        super.init()
        locManager.allowsBackgroundLocationUpdates = true
        locManager.distanceFilter = 10
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.pausesLocationUpdatesAutomatically = false
        locManager.activityType = .automotiveNavigation
        locManager.delegate = self
    }
    
    func listenForLocations(didUpdateLocations: @escaping ([CLLocation]) -> Void, failed: @escaping () -> Void)
    {
        self.didUpdateLocations = didUpdateLocations
        self.failed = failed
        requestPermission()
    }
    
    func requestPermission()
    {
        locManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            didPermissiongGranded?()
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            didPermissiongGranded?()
            manager.startUpdatingLocation()
            break
        case .restricted:
            failed?()
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            failed?()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        failed?()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations?(locations)
    }
    
    func stopListening()
    {
        locManager.stopUpdatingLocation()
    }
    
    func isLocationServiceEnabled() -> Bool {
        locManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch(locManager.authorizationStatus) {
             case .notDetermined:
                return true
             case .restricted, .denied:
                return false
             case .authorizedAlways, .authorizedWhenInUse:
                didPermissiongGranded?()
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        }
        else {
                print("Location services are not enabled")
                return false
         }
    }
    
    func canAskPermission() -> Bool
    {
        if CLLocationManager.locationServicesEnabled() {
            switch(locManager.authorizationStatus) {
             case .notDetermined:
                return true
             case .restricted, .denied:
                return false
             case .authorizedAlways, .authorizedWhenInUse:
                didPermissiongGranded?()
                return false
            default:
                print("Something wrong with Location services")
                return false
            }
        }
        else {
            print("Location services are not enabled")
            return false
         }
    }
}
