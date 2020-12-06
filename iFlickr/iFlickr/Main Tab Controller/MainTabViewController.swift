//
//  MainTabViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/6/20.
//

import UIKit
import FirebaseAuth

class MainTabViewController: UITabBarController {

    let userID = Auth.auth().currentUser?.uid

    var userPhotoStore: UserPhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        userPhotoStore = UserPhotoStore(userId: userID)
        // Do any additional setup after loading the view.
    }
    

}
