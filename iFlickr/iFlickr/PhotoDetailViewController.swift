//
//  PhotoDetailViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PhotoDetailViewController: UIViewController {


    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDateTakenLabel: UILabel!
    @IBOutlet var numOfViewsLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var dateTaken = ""
    var isFavorite: Bool?
    var photo: Photo!
    let userID = Auth.auth().currentUser?.uid
    var favoritePhotos = [SavedPhoto]()
    var ref: DatabaseReference!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        imageView.load(url: photo.remoteURL!)
        imageTitleLabel.text = photo.title
        numOfViewsLabel.text = photo.views + " views 👁️‍🗨️"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy HH:mm"
        dateTaken = dateFormatterGet.string(from: photo.dateTaken)
        imageDateTakenLabel.text = dateTaken
        ref = Database.database().reference()
        loadStoredPhotos(forId: userID)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            let favMovie = ["id": self.photo.photoID, "photoTitle": self.photo.title , "numOfViews": self.photo.views , "imageUrl": self.photo.remoteURL?.absoluteString , "dateTaken": self.dateTaken]
            if snapshot.exists() {
                //let value = snapshot.value as! NSDictionary
                let id = Auth.auth().currentUser?.uid
                self.ref.child("Users").child("\(id!)").child("FavoritePhotos").child(self.photo.photoID).setValue(favMovie)
            }
            else {
                self.ref.child("Users").child(userID!).child("FavoritePhotos").child(self.photo.photoID).setValue(favMovie)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        updateFavoriteButton()
        isFavorite = true
    }
    
    @IBAction func updateFavoriteButton() {
        if isFavorite == true {
            favoriteButton.setImage(UIImage(systemName: "star.fill" )?.withTintColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
            isFavorite = true
            favoriteButton.setTitle("", for: .normal)
            favoriteButton.isEnabled = false
        }
        else {
            favoriteButton.setImage(nil, for: .normal)
            isFavorite = false
            favoriteButton.setTitle("Add To Favorite", for: .normal)

        }
    }
    
    func loadStoredPhotos(forId userID: String?) {
        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
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
                self.checkIfPhotoExist()
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkIfPhotoExist() {
        let photoTemp = SavedPhoto(id: photo.photoID, title: photo.title, views: photo.views, date: dateTaken)
        
        if favoritePhotos.firstIndex(of: photoTemp) != nil {
            isFavorite = true
        }
        else {
            isFavorite = false
        }
        
        updateFavoriteButton()
    }
}
