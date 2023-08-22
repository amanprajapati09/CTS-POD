//
//  LocationManager.swift
//  Spendwitty
//
//  Created by Jayesh on 06/08/19.
//  Copyright © 2019 codal. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager : NSObject {
    
    static let sharedInstance = LocationManager()
    
    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    
    // Default initialization
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.showsBackgroundLocationIndicator = false
        locationManager?.delegate = self
        
        let timer = Timer(timeInterval: 5, repeats: true) { [weak self] timer in
            self?.locationManager?.startUpdatingLocation()
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func checkLocationPermission() {
        switch locationManager?.authorizationStatus {
            case .authorizedAlways:
                startUpdatingLocation()
            case .authorizedWhenInUse:
                startUpdatingLocation()
            case .denied:
                print("UNAuthorized")
            case .notDetermined:
                requestForAuthorization()
            case .restricted:
                print("UNAuthorized")
            case .none:
            print("UNAuthorized")
            @unknown default:
                print("UnKnown")
        }
    }
    
    func requestForAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
