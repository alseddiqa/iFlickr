//
//  PhotoLocationService.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
}

class PhotoLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private(set) var latitude = 0.0
    private(set) var longitude = 0.0
    
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization() // you might replace this with whenInuse
        locationManager.startUpdatingLocation()
        //sleep(10)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("-----mang")
            print(latitude)
            
            self.lastLocation = location
                    
                    // use for real time update location
            updateLocation(currentLocation: location)
        }
    }
    
    func startUpdatingLocation() {
            print("Starting Location Updates")
            self.locationManager.startUpdatingLocation()
    }
    
    private func updateLocation(currentLocation: CLLocation){

          guard let delegate = self.delegate else {
              return
          }
          
        delegate.tracingLocation(currentLocation: currentLocation)
}
    
//     func getLatitude() -> CLLocationDegrees {
//        return latitude
//    }
//    
//     func getLongitude() -> CLLocationDegrees {
//        return longitude
//    }
    
    //notification -> Multiple listeners
    //delegate -> single listener
    //completion handler pat -> Single listener (more modern)
}
