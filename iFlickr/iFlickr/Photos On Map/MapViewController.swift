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
    
    var currentLocation: CLLocation!
    var annotitionsCounter = 0
    var userPhotoStore = UserPhotoStore()
    var locationManager: PhotoLocationService!
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        getUserLocation()
        showInformationAlert()
        setUpMapView()
    }
    
    func getUserLocation() {
     
        self.locationManager = PhotoLocationService()
        locationManager.delegate = self
        
        //shows a blue point on user location
        mapView.showsUserLocation = true
        
        // zoom in the user exact location -> (left commented, just a design choice)
        //mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    func setUpMapView() {
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString
            = NSLocalizedString("Satellite", comment: "Satellite map view")
        let segmentedControl
            = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
    }
    
    @IBAction func triggerTouchAction(_ sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            if annotitionsCounter == 1 {
                mapView.removeAnnotations(mapView.annotations)
                annotitionsCounter = 0
                addAnnotation(coordinate: tappedCoordinate)
            }
            else {
                mapView.removeAnnotations(mapView.annotations)
                addAnnotation(coordinate: tappedCoordinate)
                annotitionsCounter+=1
            }
        }
    }
    
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        showPinnedLocationPhotos(coordinate: coordinate)
    }
    
    func showPinnedLocationPhotos(coordinate: CLLocationCoordinate2D)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "PinnedController") as! PinnedLocationViewController
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.popover
        destVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        destVC.cordinates = coordinate
        destVC.userPhotoStore = self.userPhotoStore
        self.present(destVC, animated: true, completion: nil)
    }
    
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func showInformationAlert() {
        let alert = UIAlertController(title: "Explore World Photos!", message: "Once you tap on any location on the map, we will show you list of photos.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok, Got it!", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension MapViewController: LocationServiceDelegate  {
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
}
