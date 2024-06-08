//
//  MapAppChooser.swift
//  CTS POD
//
//  Created by Aman Prajapati on 08/06/24.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

public enum DirectionsOpts {
    case AppleMaps
    case GoogleMaps
    case Navigon
    case Waze
    case TomTom
    case manpsWithMe
    
    public var appname: String {
        switch self {
        case .AppleMaps:
            return "Apple Maps"
        case .GoogleMaps:
            return "Google Maps"
        case .Navigon:
            return "Navigon"
        case .Waze:
            return "Waze"
        case .TomTom:
            return "TomTom"
        case .manpsWithMe:
            return "Maps.Me"
        }
    }
    public var baseUrl: String {
        switch self {
        case .AppleMaps:
            return "http://maps.apple.com"
        case .GoogleMaps:
            return "comgooglemaps://"
        case .Navigon:
            return "navigon://"
        case .Waze:
            return "waze://"
        case .TomTom:
            return "tomtomhome://"
        case .manpsWithMe:
            return "mapswithme://"
        }
    }
    
    public static let allApps: [DirectionsOpts] = [.AppleMaps, .GoogleMaps, .Navigon, .Waze]
    public static var availableApps: [DirectionsOpts] {
        return self.allApps.filter { app in app.available }
    }
    
    public var url: URL? {
        return URL(string: self.baseUrl)
    }
    
    public var available: Bool {
        guard let url = self.url else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func directionsUrlString(coordinate: CLLocationCoordinate2D, name: String = "Destination") -> String {
        
        var urlString = self.baseUrl
        
        switch self {
        case .AppleMaps:
            urlString.append("?q=\(coordinate.latitude),\(coordinate.longitude)=d&t=h")
            
        case .GoogleMaps:
            urlString.append("?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")
            
        case .Navigon:
            urlString.append("coordinate/\(name)/\(coordinate.longitude)/\(coordinate.latitude)")
            
        case .Waze:
            urlString.append("?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes")
            
        case .TomTom:
            urlString.append("?geo:action=navigateto&\(coordinate.latitude)=mylat&long=\(coordinate.longitude)&name=\(name)")
            
        case .manpsWithMe:
            urlString.append("map?v=1&ll=\(coordinate.latitude),\(coordinate.longitude)&n=\(name)&id=AnyStringOrEncodedUrl&backurl=UrlToCallOnBackButton&appname=TrackProof")
        }
        
        let urlwithPercentEscapes =
        urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        
        return urlwithPercentEscapes
    }
    
    public func directionsUrl(coordinate: CLLocationCoordinate2D, name: String = "Destination") -> URL? {
        let urlString = self.directionsUrlString(coordinate: coordinate, name: name)
        return URL(string: urlString)
    }
    
    //open the app
    public func openWithDirections(coordinate: CLLocationCoordinate2D,
                                   name: String = "Destination",
                                   completion: ((Bool) -> Swift.Void)? = nil) {
        
        // Apple Maps can be opened differently than other navigation apps
        if self == .AppleMaps {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = name
            
            let success = mapItem.openInMaps(launchOptions:
                                                [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            
            completion?(success)
        }
        
        guard let url = self.directionsUrl(coordinate: coordinate, name: name) else {
            completion?(false)
            return
        }
        
        // open the app with appropriate method for your target iOS version
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(url.absoluteString): \(success)")
                completion?(success)
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            completion?(success)
        }
    }
    
    // present available apps
    public static func directionsAlertController(coordinate: CLLocationCoordinate2D,
                                                 name: String = "Destination",
                                                 title: String = "Directions Using",
                                                 message: String? = nil,
                                                 completion: ((Bool) -> ())? = nil)
    -> UIAlertController {
        
        let directionsAlertView = UIAlertController(title: title,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
        
        for navigationApp in DirectionsOpts.availableApps {
            
            let action = UIAlertAction(title: navigationApp.appname,
                                       style: UIAlertAction.Style.default,
                                       handler: { action in
                navigationApp.openWithDirections(coordinate: coordinate,
                                                 name: name,
                                                 completion: completion)
            })
            
            directionsAlertView.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Dismiss",
                                         style: UIAlertAction.Style.cancel,
                                         handler: { action in completion?(false) })
        
        directionsAlertView.addAction(cancelAction)
        
        return directionsAlertView
    }
}
