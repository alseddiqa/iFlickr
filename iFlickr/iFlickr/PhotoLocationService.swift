//
//  PhotoLocationService.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import Foundation
import CoreLocation

class PhotoLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var latitude = 0.0
    private var longitude = 0.0
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization() // you might replace this with whenInuse
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("-----mang")
            print(latitude)
        }
    }
    
     func getLatitude() -> CLLocationDegrees {
        return latitude
    }
    
     func getLongitude() -> CLLocationDegrees {
        return longitude
    }
}
