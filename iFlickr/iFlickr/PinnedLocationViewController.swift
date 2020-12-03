//
//  PinnedLocationViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/2/20.
//

import UIKit
import CoreLocation

class PinnedLocationViewController: UITableViewController {

    var photos = [Photo]()
    var store: PhotoStore!
    var photosDataSource =
        PhotoTableDataSource()
    var cordinates: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        store = PhotoStore()
        retreivePhotosForLocation()
        
        tableView.dataSource = photosDataSource
        
    }

    func retreivePhotosForLocation() {
        self.store.fetchPhotosForLocation(lat:cordinates.latitude , lon: cordinates.longitude) {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Found \(photos.count) photos.")
                self.photosDataSource.photos = photos
            case let .failure(error):
                print("Error fetching photos: \(error)")
                self.photosDataSource.photos.removeAll()
            }
            
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        print(photos.count)
//        return photos.count
//    }
    
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
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}
