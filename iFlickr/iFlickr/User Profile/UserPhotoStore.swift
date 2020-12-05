//
//  UserPhotoStore.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/4/20.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserPhotoStore {
    
    //set up the values for server, user id to get the photos for
    let userID = Auth.auth().currentUser?.uid
    var favoritePhotos = [SavedPhoto]()
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
        if userID != nil {
            self.loadPhotos(forId: self.userID)
        }
    }
    
    /// A function that makes a call to Fire DB and fetch favortie photo for a specific user
    /// - Parameter userID: the id of the user to fetch photos for
    func loadPhotos(forId userID: String?) {
        let nc = NotificationCenter.default

        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                self.favoritePhotos.removeAll()
                let value = snapshot.value as! NSDictionary
                
                for (_, photoValues) in value {
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
                //Posting notification when the photos load is done
                nc.post(name: .photosStoreLoadedPhotos, object: self)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    /// A function that delete a photo from the store, and execute a deletion call on the server
    /// - Parameter photo: the photo to delete
    func deletePhotoFromList(photo: SavedPhoto) {
        if let index = favoritePhotos.firstIndex(of: photo) {
            favoritePhotos.remove(at: index)
        }
        
        ref.child("Users").child(userID!).child("FavoritePhotos").child(photo.photoId).removeValue()
        
    }
    
    /// A funtion tha adds a photo to the favorite list
    /// - Parameter photo: the photo to add to the list of favorite photos
    func addPhotoToList(photo: SavedPhoto) {
        let favMovie = ["id": photo.photoId, "photoTitle": photo.title , "numOfViews": photo.views , "imageUrl": photo.photoLink!.absoluteString , "dateTaken": photo.dateTaken]
        self.ref.child("Users").child(self.userID!).child("FavoritePhotos").child(photo.photoId).setValue(favMovie)
        favoritePhotos.append(photo)
    }
    
    /// A helper function to check if given photo exist in the list of favorite photos
    /// - Parameter photo: the photo to search  for
    /// - Returns: true if the photo exist in the list, false if it doesn't
    func checkIfPhotoExist(photo: SavedPhoto) -> Bool {
        if favoritePhotos.firstIndex(of: photo) != nil {
            return true
        }
        else {
            return false
        }
    }

}

extension Notification.Name {
    static let photosStoreLoadedPhotos = Notification.Name(rawValue: "photosStoreLoadedPhotos")
}
