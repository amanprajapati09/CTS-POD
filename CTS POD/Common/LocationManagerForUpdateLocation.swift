//
//  LocationManager.swift
//  Gr8dish
//
//  Created by Jayesh on 25/11/18.
//  Copyright © 2018 Jayesh kanzariya. All rights reserved.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {

    static let sharedInstance = LocationManager()
    var locationManger : CLLocationManager?
    var currentLocation : CLLocation?
    var locationPermission : ((_ status : CLAuthorizationStatus)->())?
        
    private override init() {
        super.init()
        locationManger = CLLocationManager()
        locationManger?.delegate = self
    }
    
    @discardableResult
    func checkAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            print("Allow")
            return true
        case .denied:
            print("Deny")
            return false
        case .restricted:
            print("restricted")
            return false
        case .authorizedAlways:
            print("restricted")
            return false
        case .notDetermined:
            print("Not Determine")
            return false
        @unknown default:
            fatalError()
        }
    }
    
    func requestForLocationWhenInUse() {
        locationManger?.requestWhenInUseAuthorization()
        locationManger?.allowsBackgroundLocationUpdates = true
    }
    
    func requestForAlwaysAuthorization(){
        locationManger?.requestAlwaysAuthorization()
        locationManger?.allowsBackgroundLocationUpdates = true
    }
    
    func startUpdatingLocation(){
        locationManger?.delegate = self
        locationManger?.startUpdatingLocation()
    }
    
    func startUpdateLocationWithSignificationChnage() {
        locationManger?.delegate = self
        locationManger?.startUpdatingLocation()
        locationManger?.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdatingLocation(){
        locationManger?.stopUpdatingLocation()
        locationManger?.stopMonitoringSignificantLocationChanges()
    }
    
    func getCountryCodeFromLocation(location : CLLocation,complitionHandler : @escaping ((_ countryCode : String)->()),erroHandler : @escaping ((_ error : String) -> ())){
        // Look up the location and pass it to the completion handler
        CLGeocoder().reverseGeocodeLocation(location) { (placeMark, error) in
            if error != nil{
               erroHandler(error?.localizedDescription ?? " not able to get country code")
            }
            else if let placemark = placeMark?.first{
                complitionHandler(placemark.isoCountryCode ?? "")
            }
        }
    }
}

extension LocationManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current Location : \(location)")
            if let user = LocalTempStorage.getValue(fromUserDefault: LoginDetails.self, key: UserDefaultKeys.user) {
                if let date = LocalTempStorage.getValue(key: UserDefaultKeys.lastTimeStampUpdateLocation) as? Date,
                   date.getDiffrenceBetweenDatesInMinutes() >= user.user.timeInterval {
                   LocalTempStorage.storeValue(value: Date(), key: UserDefaultKeys.lastTimeStampUpdateLocation)
                   self.postLocation(location: location)
                } else if LocalTempStorage.getValue(key: UserDefaultKeys.lastTimeStampUpdateLocation) == nil {
                    self.postLocation(location: location)
                }
            }
            currentLocation = location
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) { }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) { }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager fail with error\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermission?(status)
        switch status {
        case .notDetermined,.restricted,.denied:
            break
        case .authorizedAlways:
            startUpdateLocationWithSignificationChnage()
        case .authorizedWhenInUse:
            startUpdateLocationWithSignificationChnage()
        @unknown default:
            break
        }
    }
    
    func postLocation(location: CLLocation) {
        Task { @MainActor in
            do {
                let request = BackgroundLocatinUpdateRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, address: "", createdDate: Date().apiSupportedDate())
                try await BackgroundLocatinUpdateClient().updateLocation(requestModel: request, completion: { _ in })
            } catch {
                print(error)
            }
        }
    }
}
        

