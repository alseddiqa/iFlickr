//
//  PinnedLocationViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/2/20.
//

import UIKit
import CoreLocation

class PinnedLocationViewController: UITableViewController {

    //Declaring vars
    var store: PhotoStore!
    var photosDataSource =
        PhotoTableDataSource()
    
    //Cordinates of the pinned location on the map
    var cordinates: CLLocationCoordinate2D!
    var userPhotoStore: UserPhotoStore!
    var tabBar: MainTabViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store = PhotoStore()
        
        retrievePhotosForLocation()
        
        tableView.dataSource = photosDataSource
    }

    func retrievePhotosForLocation() {
        self.store.fetchPhotosForLocation(lat:cordinates.latitude , lon: cordinates.longitude) {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.photosDataSource.photos = photos
            case let .failure(error):
                print("Error fetching photos: \(error)")
                self.photosDataSource.photos.removeAll()
            }
            
            self.tableView.reloadData()
        }
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = photosDataSource.photos[indexPath.row]
        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            guard let photoIndex = self.photosDataSource.photos.firstIndex(of: photo),
                  case let .success(image) = result else {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // When the request finishes, find the current cell for this photo
            if let cell = self.tableView.cellForRow(at: photoIndexPath)
                as? PhotoTableViewCell {
                cell.update(displaying: image)
                
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow?.row {
                let photo = photosDataSource.photos[selectedIndexPath]
                let destinationVC = segue.destination as! PhotoDetailViewController
                destinationVC.photo = photo
                destinationVC.userPhotoStore = self.userPhotoStore
                destinationVC.tabBar = self.tabBar
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}
