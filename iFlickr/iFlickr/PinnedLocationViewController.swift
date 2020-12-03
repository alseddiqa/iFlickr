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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(photos.count)
        return photos.count
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell", for: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]
        print(photo.title)

        cell.photoTitleLabel.text = photo.title
        cell.imageView?.load(url: photo.remoteURL!)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
