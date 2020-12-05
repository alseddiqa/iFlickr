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
    
    let userID = Auth.auth().currentUser?.uid
    var userPhotoStore: UserPhotoStore!
    var ref: DatabaseReference!
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userPhotoStore = UserPhotoStore()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeStoreLoadNotification(note:)),
                                               name: .photosStoreLoadedPhotos,
                                               object: nil)
        getUserInformation(forId: userID)
        favoriteLabel.text = "Favorite Photos ⭐"
    }
    
    @objc func observeStoreLoadNotification(note: Notification) {
        tableView.reloadData()
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
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userPhotoStore.favoritePhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritePhotoTableViewCell
        let photo = userPhotoStore.favoritePhotos[indexPath.row]
        cell.photoTitle.text = photo.title
        cell.photoViews.text = photo.views + " views"
        cell.photoDate.text = photo.dateTaken
        cell.photoImageView.load(url: photo.photoLink!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let photo = userPhotoStore.favoritePhotos[indexPath.row]
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
        // Also remove that row from the table view with an animation
        userPhotoStore.deletePhotoFromList(photo: photo)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
