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
    
    let userID = Auth.auth().currentUser?.uid
    var favoritePhotos = [SavedPhoto]()
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
        loadPhotos(forId: userID)
    }
    
    func loadPhotos(forId userID: String?) {
        let nc = NotificationCenter.default

        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists() {
                self.favoritePhotos.removeAll()
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
                nc.post(name: .photosStoreLoadedPhotos, object: self)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func deletePhotoFromList(photo: SavedPhoto) {
        if let index = favoritePhotos.firstIndex(of: photo) {
            favoritePhotos.remove(at: index)
        }
        ref.child("Users").child(userID!).child("FavoritePhotos").child(photo.photoId).removeValue()
    }
    
    func addPhotoToList(photo: SavedPhoto) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("FavoritePhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            let favMovie = ["id": photo.photoId, "photoTitle": photo.title , "numOfViews": photo.views , "imageUrl": photo.photoLink!.absoluteString , "dateTaken": photo.dateTaken]
            if snapshot.exists() {
                //let value = snapshot.value as! NSDictionary
                let id = Auth.auth().currentUser?.uid
                self.ref.child("Users").child("\(id!)").child("FavoritePhotos").child(photo.photoId).setValue(favMovie)
            }
            else {
                self.ref.child("Users").child(userID!).child("FavoritePhotos").child(photo.photoId).setValue(favMovie)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
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
