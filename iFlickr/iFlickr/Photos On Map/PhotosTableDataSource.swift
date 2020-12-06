//
//  PhotosTableDataSource.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/2/20.
//

import UIKit

class PhotoTableDataSource: NSObject, UITableViewDataSource {
    
    //Declare an array of photos
    var photos = [Photo]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    /// A funtion to configure the cell of the table view for the pinned location
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: index of the cell to configure
    /// - Returns: the cell after configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell", for: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]

        cell.photoTitleLabel.text = photo.title
        cell.update(displaying: nil)
        return cell
    }
    
}
