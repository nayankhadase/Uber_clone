//
//  LocationManager.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 15/07/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // ask for permission
        locationManager.startUpdatingLocation() // start updating user location
        
    }
}
extension LocationManager: CLLocationManagerDelegate{
    // we cant ask user location from MkMap view so we need CLLocationManager for that and rest we will handle in mapview coordinator
    
    // we will ask permision, get user location and stop stopUpdatingLocation because rest we will handle in mapview(coordinator)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {return}
        
        locationManager.stopUpdatingLocation() // stop updating location
    }
}
