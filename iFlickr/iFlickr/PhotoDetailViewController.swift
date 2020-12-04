//
//  PhotoDetailViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import UIKit

class PhotoDetailViewController: UIViewController {


    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDateTakenLabel: UILabel!
    @IBOutlet var numOfViewsLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var dateTaken = ""
    var isFavorite: Bool?
    var photo: Photo!
    var userPhotoStore: UserPhotoStore!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        imageView.load(url: photo.remoteURL!)
        imageTitleLabel.text = photo.title
        numOfViewsLabel.text = photo.views + " views 👁️‍🗨️"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy HH:mm"
        dateTaken = dateFormatterGet.string(from: photo.dateTaken)
        imageDateTakenLabel.text = dateTaken
        checkIfPhotoExistInFavList()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFavoriteMovie(_ sender: UIButton) {
        let photoTemp = SavedPhoto(id: photo.photoID, title: photo.title, views: photo.views, date: dateTaken)
        photoTemp.photoLink = photo.remoteURL
        userPhotoStore.addPhotoToList(photo: photoTemp)
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
    
    func checkIfPhotoExistInFavList() {
        let photoTemp = SavedPhoto(id: photo.photoID, title: photo.title, views: photo.views, date: dateTaken)
        isFavorite = userPhotoStore.checkIfPhotoExist(photo: photoTemp)
        updateFavoriteButton()
    }
    
    
}
