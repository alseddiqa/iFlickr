//
//  PhotosTableDataSource.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/2/20.
//

import UIKit

class PhotoTableDataSource: NSObject, UITableViewDataSource {
    
    var photos = [Photo]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableCell", for: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]
        print(photo.title)

        cell.photoTitleLabel.text = photo.title
        cell.update(displaying: nil)
        return cell
    }
    
}
