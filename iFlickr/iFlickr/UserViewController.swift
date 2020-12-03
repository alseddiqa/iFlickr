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
        
        loadMovies(forId: userID)
        loadWatchListMovies(forId: userID)
        
        moviesTypesSegmentController.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
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
    
    func loadMovies(forId userID: String?) {
        ref.child("Users").child(userID!).child("FavoriteMovies").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                self.favoriteMovies.removeAll()
                let value = snapshot.value as! NSDictionary
                
                for (key, movieValues) in value {
                    
                    let movieInfo = movieValues as! NSDictionary
                    let title = movieInfo["movieName"] as? String ?? ""
                    //                let backImage = movieInfo["movieBackImage"]
                    let posterUrl = movieInfo["posterImageUrl"] as? String ?? ""
                    let overView = movieInfo["movieOverView"] as? String ?? ""
                    let rating = movieInfo["movieRating"] as? String ?? ""
                    
                    let movie = SavedMovie(title: title, rate: rating, overview: overView)
                    movie.posterImage = URL(string: posterUrl)
                    self.favoriteMovies.append(movie)
                    
                }
                self.movies = self.favoriteMovies
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
        return movies.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.movieDescription.text = movie.overview
        cell.movieRating.text = "\(movie.rate)"
        cell.movieImage.load(url: movie.posterImage!)
        
        return cell
    }
    
    func loadWatchListMovies(forId userID: String?) {
        ref.child("Users").child(userID!).child("WatchListMovies").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                print("----------")
                self.watchListMovies.removeAll()
                
                let value = snapshot.value as! NSDictionary
                
                for (key, movieValues) in value {
//                    print("key \(key)")
//                    print("vak \(movieValues)")
                    
                    let movieInfo = movieValues as! NSDictionary
                    let title = movieInfo["movieName"] as? String ?? ""
                    //                let backImage = movieInfo["movieBackImage"]
                    let posterUrl = movieInfo["posterImageUrl"] as? String ?? ""
                    let overView = movieInfo["movieOverView"] as? String ?? ""
                    let rating = movieInfo["movieRating"] as? String ?? ""
                    
                    let movie = SavedMovie(title: title, rate: rating, overview: overView)
                    movie.posterImage = URL(string: posterUrl)
                    self.watchListMovies.append(movie)
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func changeMoviesList(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            movies = favoriteMovies
        }
        else {
            movies = watchListMovies
        }
        tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
