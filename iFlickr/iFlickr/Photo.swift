//
//  Photo.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import Foundation

class Photo: Codable {
    
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    let latitude, longitude, accuracy: String
    let views: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
        case latitude
        case longitude
        case accuracy
        case views
    }
    
}

class SavedPhoto: Codable{
    var title: String
    var views: String
    var dateTaken: String
    var photoLink: URL?
    
    init(title: String, views: String, date: String) {
        self.title = title
        self.views = views
        self.dateTaken = date
    }
}


struct FlickrResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}
struct FlickrPhotosResponse: Codable {
    let photos: [Photo]
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // Two Photos are the same if they have the same photoID
        return lhs.photoID == rhs.photoID
    }
}
