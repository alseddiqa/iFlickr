//
//  UserViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserViewController: UITableViewController {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var favoriteLabel: UILabel!
    
    var favoritePhotos = [SavedPhoto]()
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPhotos(forId: userID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation(forId: userID)
        favoriteLabel.text = "Favorite Photos ⭐"
    }
    
    func getUserInformation(forId userID: String?) {
        spinner.startAnimating()
        ref = Database.database().reference()
        if userID != nil {
            ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.spinner.startAnimating()
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let email = value?["emailAddress"] as? String ?? ""
                self.userName.text = name
                self.userEmail.text = email
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func loadPhotos(forId userID: String?) {
        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                self.favoritePhotos.removeAll()
                let value = snapshot.value as! NSDictionary
                
                for (key, photoValues) in value {
                    
                    let photoInfo = photoValues as! NSDictionary
                    let id = photoInfo["id"] as? String ?? ""
                    let title = photoInfo["photoTitle"] as? String ?? ""
                    let posterUrl = photoInfo["imageUrl"] as? String ?? ""
                    let dateTaken = photoInfo["dateTaken"] as? String ?? ""
                    let numOfViews = photoInfo["numOfViews"] as? String ?? ""
                    
                    let photo = SavedPhoto(id: id, title: title, views: numOfViews, date: dateTaken)
                    photo.photoLink = URL(string: posterUrl)
                    self.favoritePhotos.append(photo)
                    
                }
                self.tableView.reloadData()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritePhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritePhotoTableViewCell
        let photo = favoritePhotos[indexPath.row]
        cell.photoTitle.text = photo.title
        cell.photoViews.text = photo.views + "views"
        cell.photoDate.text = photo.dateTaken
        cell.photoImageView.load(url: photo.photoLink!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let photo = favoritePhotos[indexPath.row]
            let title = NSLocalizedString("Are you sure about this deletion?", comment: "")
            let message = NSLocalizedString("You better be sure :)", comment: "")
            let acceptRespone = NSLocalizedString("Yes, I'm aware of consequences", comment: "")
            let noResponse = NSLocalizedString("No, backup", comment: "")

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: acceptRespone, style: .destructive, handler: { action in
                self.deleteSafely(photo: photo, indexPath: indexPath)
            }))
            
            alert.addAction(UIAlertAction(title: noResponse, style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func deleteSafely(photo: SavedPhoto , indexPath: IndexPath) {
        if let index = favoritePhotos.firstIndex(of: photo) {
            favoritePhotos.remove(at: index)
        }
        // Also remove that row from the table view with an animation
        tableView.deleteRows(at: [indexPath], with: .automatic)
        ref.child("Users").child(userID!).child("FavoritePhotos").child(photo.photoId).removeValue()
    }
}
