//
//  SavedPhoto.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import Foundation

class SavedPhoto: Equatable{
    static func == (lhs: SavedPhoto, rhs: SavedPhoto) -> Bool {
        return lhs.photoId == rhs.photoId
    }
    
    var photoId:String
    var title: String
    var views: String
    var dateTaken: String
    var photoLink: URL?
    
    init(id: String , title: String, views: String, date: String) {
        self.photoId = id
        self.title = title
        self.views = views
        self.dateTaken = date
    }
}
