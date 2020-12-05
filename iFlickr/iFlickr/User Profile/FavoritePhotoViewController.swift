//
//  FavoritePhotoViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/5/20.
//

import UIKit

///A  view controller to show the favorite photo
class FavoritePhotoViewController: UIViewController {

    var photo: SavedPhoto!
    @IBOutlet var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageView.load(url: photo.photoLink!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
