//
//  MapViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUserLocation()
    }
    
    func getUserLocation() {
        // setting up the location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
        
        //shows a blue point on user location
        mapView.showsUserLocation = true
        
        // Zoom in to the user location, after locating it
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            var locationLatLan = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
            print(locationLatLan)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
