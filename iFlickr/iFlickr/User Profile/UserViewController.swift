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
    @IBOutlet var moviesTypesSegmentController: UISegmentedControl!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var favoritePhotos = [Photo]()
    
    var ref: DatabaseReference!
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        spinner.startAnimating()
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
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
        
        loadPhotos(forId: userID)
//        loadWatchListMovies(forId: userID)
//
//        moviesTypesSegmentController.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let user = Auth.auth().currentUser
        
        if user == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(destVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadPhotos(forId userID: String?) {
        ref.child("Users").child(userID!).child("FavoriteMovies").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                self.favoritePhotos.removeAll()
                let value = snapshot.value as! NSDictionary
                
                for (key, photoValues) in value {
                    
                    let movieInfo = photoValues as! NSDictionary
                    let title = movieInfo["movieName"] as? String ?? ""
                    //                let backImage = movieInfo["movieBackImage"]
                    let posterUrl = movieInfo["posterImageUrl"] as? String ?? ""
                    let dateTaken = movieInfo["movieOverView"] as? String ?? ""
                    let numOfViews = movieInfo["movieRating"] as? String ?? ""
                    
                    let photo = SavedPhoto(title: title, views: numOfViews, date: dateTaken)
                    photo.photoLink = URL(string: posterUrl)
                    self.favoriteMovies.append(photo)
                    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = favoritePhotos[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.movieDescription.text = movie.overview
        cell.movieRating.text = "\(movie.rate)"
        cell.movieImage.load(url: movie.posterImage!)
        
        return cell
    }
}
