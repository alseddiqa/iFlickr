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

    var ref: DatabaseReference!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDateTakenLabel: UILabel!
    @IBOutlet var numOfViewsLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var dateTaken = ""
    var isFavorite = false
    var photo: Photo!
    
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFavoriteMovie(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            let favMovie = ["photoTitle": self.photo.title , "numOfViews": self.photo.views , "imageUrl": self.photo.remoteURL?.absoluteString , "dateTaken": self.dateTaken]
            if snapshot.exists() {
                //let value = snapshot.value as! NSDictionary
                let id = Auth.auth().currentUser?.uid
                self.ref.child("Users").child("\(id!)").child("FavoritePhotos").childByAutoId().setValue(favMovie)
            }
            else {
                self.ref.child("Users").child(userID!).child("FavoritePhotos").childByAutoId().setValue(favMovie)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        updateFavoriteButton()
    }
    
    @IBAction func updateFavoriteButton() {
        if isFavorite == false {
            favoriteButton.setImage(UIImage(systemName: "star.fill" )?.withTintColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
            isFavorite = true
            favoriteButton.setTitle("", for: .normal)
        }
        else {
            favoriteButton.setImage(nil, for: .normal)
            isFavorite = false
            favoriteButton.setTitle("Favorite", for: .normal)

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
