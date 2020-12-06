//
//  PhotoDetailViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    // Declaring outlets of the detail view
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDateTakenLabel: UILabel!
    @IBOutlet var numOfViewsLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    //Declaring variables holding information about
    var dateTaken = "" // string holding date value
    var isFavorite: Bool? // a vlaue to be set to true or false if the photo is in the favorite list of the user
    var photo: Photo! // photo variable
    var userPhotoStore: UserPhotoStore! // user store holding the favorite photos
    var tabBar: MainTabViewController!

    override func viewDidDisappear(_ animated: Bool) {
        tabBar.userPhotoStore = self.userPhotoStore
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Setting up the values of the clicked image from the other views
        imageView.load(url: photo.remoteURL!)
        imageTitleLabel.text = photo.title
        numOfViewsLabel.text = photo.views + " views 👁️‍🗨️"
        
        //Get the date of the photo and turn it to a string
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy HH:mm"
        dateTaken = dateFormatterGet.string(from: photo.dateTaken)
        imageDateTakenLabel.text = dateTaken
        checkIfPhotoExistInFavList()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// A function that adds an image to the user
    /// - Parameter sender: the add button
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
        let photoTemp = SavedPhoto(id: photo.photoID, title: photo.title, views: photo.views, date: dateTaken)
        photoTemp.photoLink = photo.remoteURL
        userPhotoStore.addPhotoToList(photo: photoTemp)
        updateFavoriteButton()
        isFavorite = true
    }
    
    /// A function tha will disable the add button if
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
    
    /// A helper function that calls the stores check, to see if the curent viewed photo is 
    func checkIfPhotoExistInFavList() {
        let photoTemp = SavedPhoto(id: photo.photoID, title: photo.title, views: photo.views, date: dateTaken)
        isFavorite = userPhotoStore.checkIfPhotoExist(photo: photoTemp)
        updateFavoriteButton()
    }
    
    
}
