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
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
        case latitude
        case longitude
        case accuracy
    }
    
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // Two Photos are the same if they have the same photoID
        return lhs.photoID == rhs.photoID
    }
}
