//
//  LocationManager.swift
//  Bus
//
//  Created by Timothy on 28/11/23.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var manager: CLLocationManager?
        
    // Checks if LS is enabled, configures location manager
    func checkIfLocationServicesIsEnabled() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
//        manager?.startUpdatingLocation()
    }
    
    // Checks current authorization status afor LS
    private func checkLocationAuthorization() {
        guard let manager = manager else { return }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Services restriced.")
        case .denied:
            print("This app has been denied Location Services.")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    // Called when LS authorization status has changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
