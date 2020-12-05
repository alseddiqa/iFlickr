//
//  ImageStore.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import UIKit

class ImageStore {
    
    //Declaring the Cache
    let cache = NSCache<NSString, UIImage>()
    
    /// A function that add an image with a specified key
    /// - Parameters:
    ///   - image: the image
    ///   - key: the identifier for the photo
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        //Create full url for an image
        let url = imageURL(forKey: key)
        
        //Turning data to JPEG
        if let data = image.jpegData(compressionQuality: 0.5)
        {
            //write the full url
            try? data.write(to: url)
        }
    }
    
    func image(forKey key:String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
        
    }
    
    /// A helper function to remove photo from cache
    /// - Parameter key: the identifier for the photo
    func deleteImageFromCache(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            print("Error removing the image from the disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
}
