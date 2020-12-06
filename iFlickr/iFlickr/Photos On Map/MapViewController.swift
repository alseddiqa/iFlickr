//
//  MapViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //Declaring map view outlet
    @IBOutlet var mapView: MKMapView!
    
    //Declaring variables for the VC
    var currentLocation: CLLocation!   // current location of the user
    var annotitionsCounter = 0  // annotation counter to keep track of how many on the map
    var userPhotoStore = UserPhotoStore()  // the signed in user photo store
    var locationManager: PhotoLocationService! //location service class to current location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        showInformationAlert()
        setUpMapView()
    }
    
    /// A function used to get the user location when the view is loaded
    func getUserLocation() {
     
        self.locationManager = PhotoLocationService()
        locationManager.delegate = self
        
        //shows a blue point on user location
        mapView.showsUserLocation = true
        
        // zoom in the user exact location -> (left commented, just a design choice)
        //mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    /// A functiom hat adds a segment controller to the map with diffrent view
    func setUpMapView() {
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        
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
    
    /// A  function that handles the tap on the map, and gets the location where the user tapped
    /// - Parameter sender: tap gesture recognizer
    @IBAction func triggerTouchAction(_ sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            //Making sure only one annotation is placed on the map
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
    
    /// A function that adds annotion on map for the sent cordinates where the user tapped
    /// - Parameter coordinate: location of where the user tapped
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        showPinnedLocationPhotos(coordinate: coordinate)
    }
    
    /// A function that pops the VC to show the list of photos for the pinned location
    /// - Parameter coordinate: the location where the user tapped -> location of the annoation
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
    
    
    /// A function that handles the map view type change
    /// - Parameter segControl: segment controller
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
    
    /// A function that shows the user an alert to tell more about how to use the map vc
    func showInformationAlert() {
        let alert = UIAlertController(title: "Explore The World!", message: "Once you tap on any location on the map, we will show you list of photos for it.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok, Got it!", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension MapViewController: LocationServiceDelegate  {
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
    }
}
